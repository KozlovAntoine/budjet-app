import 'package:budjet_app/ad_manager.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Revenu.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/RevenuDAO.dart';
import 'package:budjet_app/pages/add/PageAddRevenu.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/RevenuCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'BottomNav.dart';
import 'CustomMainPage.dart';

class PageRevenus extends StatefulWidget {
  _PageRevenusState createState() => _PageRevenusState();
}

class _PageRevenusState extends State<PageRevenus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool dbLoaded = false;
  late RevenuDAO dao;
  late CompteDAO compteDAO;
  List<RevenuCard> widgets = [];
  List<Compte> comptes = [];
  late DateTime selectedDate;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dao = RevenuDAO();
    compteDAO = CompteDAO();
    refresh();
    AdManager.incr();
    print('Interaction : ' + AdManager.interaction.toString());
    _createInterstitialAd();
  }

  @override
  void didUpdateWidget(covariant PageRevenus oldWidget) {
    dbLoaded = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  void _createInterstitialAd() async {
    await InterstitialAd.load(
        adUnitId: 'ca-app-pub-1489348380925914/7488829439',
        request: AdManager.request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            if (AdManager.showAd) _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    AdManager.closeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes revenus",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        initialDate: DateTime.now(),
        changeDate: (date) {
          selectedDate = date;
          refresh();
        },
      ),
      floatingActionButton: comptes.isEmpty
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PageAddRevenu(
                              comptes: comptes,
                            )))
                    .then((value) async {
                  if (value != null && value is Revenu) {
                    print(value);
                    await dao.insertAll(value);
                    refresh();
                    AdManager.incr();
                  }
                });
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: dbLoaded
          ? CustomMainPage(
              children: widgets,
              scaffoldKey: _scaffoldKey,
              text: comptes.isEmpty ? 'Vous devez ajouter un compte.' : 'Vide',
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  refresh() async {
    widgets = [];
    List<Revenu> revenues = await dao.tousLesRevenusDunMois(selectedDate);
    comptes = await compteDAO.getAll();
    for (var element in revenues) {
      widgets.add(RevenuCard(
        revenu: element,
        onDelete: delete,
      ));
    }
    //print(revenues);
    setState(() {
      dbLoaded = true;
      //print('setstate');
    });
  }

  void delete(Revenu r) async {
    await dao.delete(r);
    refresh();
  }
}
