import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/TransactionDAO.dart';
import 'package:budjet_app/pages/add/PageAddCompte.dart';
import 'package:budjet_app/pages/main/BottomNav.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/CompteCard.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    dao = CompteDAO();
    transactionDAO = TransactionDAO();
    compteLoaded = false;
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
    print('debut refresh');
    for (var element in comptes) {
      List<TransactionBud> tmp =
          await transactionDAO.transactionUnCompteJusquaAujourdhui(element.id!);
      double total = 0;
      tmp.forEach((e) {
        total += e.montant;
      });
      print('total:$total');
      if (element.transactionId != null) {
        print('id:${element.transactionId}');
        TransactionBud trans =
            await transactionDAO.getFromId(element.transactionId!);
        print('on recup $trans');
        widgets.add(ComptesCard(
          delete: delete,
          compte: element,
          transaction: trans,
        ));
      } else {
        print('element.transactionId VIDE');
        widgets.add(ComptesCard(
          delete: delete,
          compte: element,
        ));
      }
    }
    print('dddddd');
    print(comptes);
    print('fin refresh');
    setState(() {
      compteLoaded = true;
      print('setState');
    });
  }

  void delete(Compte c) async {
    await dao.delete(c);
    await refresh();
  }
}
