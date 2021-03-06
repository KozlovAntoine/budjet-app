import 'package:budjet_app/ad_manager.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/convert/DateHelper.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/VirementDAO.dart';
import 'package:budjet_app/pages/add/PageAddVirement.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/VirementCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PageVirement extends StatefulWidget {
  @override
  _PageVirementState createState() => _PageVirementState();
}

class _PageVirementState extends State<PageVirement> {
  List<VirementCard> cards = [];
  List<Compte> comptes = [];
  late CompteDAO compteDAO;
  late VirementDAO dao;
  bool dbLoaded = false;
  InterstitialAd? _interstitialAd;

  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    dao = VirementDAO();
    compteDAO = CompteDAO();
    refresh();
    AdManager.incr();
    print('Interaction : ' + AdManager.interaction.toString());
    _createInterstitialAd();
  }

  @override
  void didUpdateWidget(covariant PageVirement oldWidget) {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes virements",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: comptes.length > 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            PageAddVirement(comptes: comptes)))
                    .then((value) async {
                  if (value != null && value is Virement) {
                    await insertAll(value);
                    refresh();
                    AdManager.incr();
                  }
                });
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : Container(),
      body: dbLoaded
          ? CustomMainPage(
              children: cards,
              scaffoldKey: _scaffoldKey,
              text: comptes.length > 1
                  ? 'Vide'
                  : 'Il faut ajouter au moins 2 comptes.',
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  refresh() async {
    cards = [];
    List<Virement> virements = await dao.getAll();
    comptes = await compteDAO.getAll();
    //print('virements $virements');
    for (var element in virements) {
      cards.add(VirementCard(
        virement: element,
        onDelete: delete,
      ));
    }
    //print(comptes.length);
    //print(virements);
    setState(() {
      dbLoaded = true;
      //print('setState');
    });
  }

  void delete(Virement v) async {
    await dao.delete(v);
    refresh();
  }

  Future<void> insertAll(Virement t) async {
    DateTime tmp =
        DateTime(t.dateInitial.year, t.dateInitial.month, t.dateInitial.day);
    while (!tmp.isAfter(t.dateFin)) {
      Virement tmpV = Virement(
          depuis: t.depuis,
          vers: t.vers,
          montant: t.montant,
          type: t.type,
          id: t.id,
          dateInitial: t.dateInitial,
          dateFin: t.dateFin,
          dateActuel: tmp);
      await dao.insert(tmpV);
      //on ajoute un mois
      tmp = DateHelper.ajoutMois(tmp);
    }
  }
}
