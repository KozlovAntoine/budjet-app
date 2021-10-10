import 'package:budjet_app/ad_manager.dart';
import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
import 'package:budjet_app/pages/add/PageAddCategorie.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/CategorieCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PageCategories extends StatefulWidget {
  @override
  _PageCategoriesState createState() => _PageCategoriesState();
}

class _PageCategoriesState extends State<PageCategories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<CategorieCard> widgets = [];
  late CategorieDAO dao;
  bool categorieLoaded = false;
  InterstitialAd? _interstitialAd;

  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    dao = CategorieDAO();
    categorieLoaded = false;
    refresh();
    AdManager.incr();
    print('Interaction : ' + AdManager.interaction.toString());
    _createInterstitialAd();
  }

  @override
  void didUpdateWidget(covariant PageCategories oldWidget) {
    categorieLoaded = false;
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
    //print('build');
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes catégories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PageAddCategorie()))
              .then((value) async {
            if (value != null && value is Categorie) {
              //print(value);
              await dao.insert(value);
              refresh();
              AdManager.incr();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: categorieLoaded
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
    List<Categorie> categories = await dao.getAll();
    for (var element in categories) {
      double p = await dao.pourcentageCategorie(element);
      widgets.add(CategorieCard(
        categorie: element,
        pourcentage: p,
        onDelete: delete,
      ));
    }
    //print('dddddd');
    //print(categories);
    setState(() {
      categorieLoaded = true;
      //print('setState');
    });
  }

  void delete(Categorie c) async {
    await dao.delete(c);
    refresh();
  }
}
