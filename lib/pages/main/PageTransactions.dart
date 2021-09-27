import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/TransactionDAO.dart';
import 'package:budjet_app/pages/add/PageAddTransaction.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/TransactionCard.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    dao = TransactionDAO();
    compteDAO = CompteDAO();
    categorieDAO = CategorieDAO();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
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
        text: 'Il faut ajouter au moins un compte et une catégorie',
      ),
    );
  }

  floatButton() {
    if (categories.isNotEmpty && comptes.isNotEmpty) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => PageAddTransaction(
                        comptes: comptes,
                        categories: categories,
                      )))
              .then((value) async {
            if (value != null && value is TransactionBud) {
              await dao.insert(value);
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
    List<TransactionBud> transactions = await dao.getAll();
    comptes = await compteDAO.getAll();
    categories = await categorieDAO.getAll();
    transactions.forEach((element) {
      widgets.add(TransactionCard(transaction: element));
    });
    print(comptes);
    print(categories);
    print(transactions);
    setState(() {
      dbLoaded = true;
      print('setState');
    });
  }
}
