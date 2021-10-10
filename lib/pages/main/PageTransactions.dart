import 'package:budjet_app/ad_manager.dart';
import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/TransactionDAO.dart';
import 'package:budjet_app/pages/add/PageAddTransaction.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/TransactionCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'BottomNav.dart';

class PageTransaction extends StatefulWidget {
  _PageTransactionState createState() => _PageTransactionState();
}

class _PageTransactionState extends State<PageTransaction> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> widgets = [];
  List<Compte> comptes = [];
  List<Categorie> categories = [];
  late TransactionDAO dao;
  late CompteDAO compteDAO;
  late CategorieDAO categorieDAO;
  bool dbLoaded = false;
  late DateTime selectedDate;
  InterstitialAd? _interstitialAd;

  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    dao = TransactionDAO();
    compteDAO = CompteDAO();
    categorieDAO = CategorieDAO();
    selectedDate = DateTime.now();
    refresh();
    AdManager.incr();
    print('Interaction : ' + AdManager.interaction.toString());
    _createInterstitialAd();
  }

  @override
  void didUpdateWidget(covariant PageTransaction oldWidget) {
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
      bottomNavigationBar: BottomNav(
        initialDate: DateTime.now(),
        changeDate: (date) {
          selectedDate = date;
          refresh();
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes transactions",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: floatButton(),
      body: CustomMainPage(
        children: widgets,
        scaffoldKey: _scaffoldKey,
        text: categories.isNotEmpty && comptes.isNotEmpty
            ? 'Vide'
            : 'Il faut ajouter au moins un compte et une catégorie',
      ),
    );
  }

  floatButton() {
    if (categories.isNotEmpty && comptes.isNotEmpty) {
      return FloatingActionButton(
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => PageAddTransaction(
                        comptes: comptes,
                        categories: categories,
                      )))
              .then((newTransaction) async {
            if (newTransaction != null && newTransaction is TransactionBud) {
              await dao.insertAll(newTransaction);
              refresh();
              AdManager.incr();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      );
    } else
      Container();
  }

  refresh() async {
    widgets = [];
    List<TransactionBud> transactions =
        await dao.toutesLesTransactionsDunMois(selectedDate);
    comptes = await compteDAO.getAll();
    categories = await categorieDAO.getAll();
    TransactionBud.dateDecroissant(transactions);
    for (var element in transactions) {
      widgets.add(TransactionCard(
        transaction: element,
        onDelete: delete,
      ));
    }
    setState(() {
      dbLoaded = true;
    });
  }

  void delete(TransactionBud t) async {
    await dao.delete(t);
    refresh();
  }
}
