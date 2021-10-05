import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/convert/DateHelper.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/TransactionDAO.dart';
import 'package:budjet_app/pages/add/PageAddTransaction.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/TransactionCard.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    dao = TransactionDAO();
    compteDAO = CompteDAO();
    categorieDAO = CategorieDAO();
    selectedDate = DateTime.now();
    refresh();
  }

  @override
  void didUpdateWidget(covariant PageTransaction oldWidget) {
    dbLoaded = false;
    super.didUpdateWidget(oldWidget);
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
              await insertAll(newTransaction);
              refresh();
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
        await dao.getAllFromThisMonth(selectedDate);
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

  Future<void> insertAll(TransactionBud t) async {
    DateTime tmp =
        DateTime(t.dateInitial.year, t.dateInitial.month, t.dateInitial.day);
    while (!tmp.isAfter(t.dateFin)) {
      TransactionBud tmpTransac = TransactionBud(
          categorie: t.categorie,
          compte: t.compte,
          montant: t.montant,
          nom: t.nom,
          type: t.type,
          id: t.id,
          dateInitial: t.dateInitial,
          dateFin: t.dateFin,
          dateActuel: tmp);
      await dao.insert(tmpTransac);
      //on ajoute un mois
      tmp = DateHelper.ajoutMois(tmp);
    }
  }

  void delete(TransactionBud t) async {
    await dao.delete(t);
    refresh();
  }
}
