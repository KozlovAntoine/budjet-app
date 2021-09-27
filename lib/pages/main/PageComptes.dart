import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/pages/add/PageAddCompte.dart';
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
  List<Widget> widgets = [];
  bool compteLoaded = false;

  @override
  void initState() {
    super.initState();
    dao = CompteDAO();
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
    comptes.forEach((element) {
      widgets.add(ComptesCard(
          delete: delete,
          transaction: TransactionBud(
            categorie: Categorie(
                color: Colors.orange,
                icon: Icons.phone,
                nom: 'telephone',
                plafond: 200,
                id: 213),
            montant: 24.99,
            date: DateTime.now(),
            dateFin: DateTime.now(),
            nom: 'Orange',
            type: TypeTransaction.IMMEDIAT,
            compte: element,
          )));
    });
    print('dddddd');
    print(comptes);
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
