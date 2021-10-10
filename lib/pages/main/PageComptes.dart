import 'package:budjet_app/ad_manager.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/TransactionDAO.dart';
import 'package:budjet_app/pages/add/PageAddCompte.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/CompteCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PageCompte extends StatefulWidget {
  @override
  _MesComptesPageState createState() => _MesComptesPageState();
}

class _MesComptesPageState extends State<PageCompte> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late CompteDAO dao;
  late TransactionDAO transactionDAO;
  List<Widget> widgets = [];
  bool compteLoaded = false;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    dao = CompteDAO();
    transactionDAO = TransactionDAO();
    compteLoaded = false;
    refresh();
    AdManager.incr();
    print('Interaction : ' + AdManager.interaction.toString());
    _createInterstitialAd();
  }

  @override
  void didUpdateWidget(covariant PageCompte oldWidget) {
    compteLoaded = false;
    super.didUpdateWidget(oldWidget);
    refresh();
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
          "Mes comptes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PageAddCompte()))
              .then((value) async {
            if (value != null && value is Compte) {
              await dao.insert(value);
              refresh();
              AdManager.incr();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: compteLoaded
          ? CustomMainPage(
              children: widgets,
              scaffoldKey: _scaffoldKey,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  refresh() async {
    widgets = [];
    List<Compte> comptes = await dao.getAll();
    for (var element in comptes) {
      double sortie = await dao.getSortieDuMois(element.id!);
      double entree = await dao.getEntreeDuMois(element.id!);
      double debutMois = await dao.getSoldeDebutDuMois(element.id!);
      widgets.add(ComptesCard(
        onDelete: delete,
        compte: element,
        entree: entree,
        sortie: sortie,
        finDuMois: debutMois + entree - sortie,
      ));
    }
    setState(() {
      compteLoaded = true;
    });
  }

  void delete(Compte c) async {
    await dao.delete(c);
    refresh();
  }
}
