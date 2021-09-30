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
              int transactionId = await dao.insert(newTransaction);
              print('new id : $transactionId');
              Compte compte =
                  await compteDAO.getFromId(newTransaction.compte.id!);
              if (compte.transactionId == null) {
                compte.transactionId = transactionId;
                print('compte:$compte');
                await compteDAO.update(compte);
                print('Update');
              } else {
                TransactionBud transactionFromCompte =
                    await dao.getFromId(compte.transactionId!);
                if (newTransaction.date.isAfter(transactionFromCompte.date)) {
                  compte.transactionId = transactionId;
                  print('compte:$compte');
                  await compteDAO.update(compte);
                  print('Update');
                }
              }
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
    print('date refresh : $selectedDate');
    print('all');
    print(await dao.getAll());
    List<TransactionBud> transactions = await dao.getAllFromDate(selectedDate);
    print('tr : $transactions');
    comptes = await compteDAO.getAll();
    categories = await categorieDAO.getAll();
    TransactionBud.dateDecroissant(transactions);
    transactions.forEach((element) {
      widgets.add(TransactionCard(
        transaction: element,
        delete: delete,
      ));
    });
    setState(() {
      dbLoaded = true;
      print('setState');
    });
  }

  void delete(TransactionBud t) async {
    print('delete :$t');
    await dao.delete(t);
    await refresh();
  }
}
