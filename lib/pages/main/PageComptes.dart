import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/data/database_bud.dart';
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
  late DatabaseBud databaseBud;
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    initDatabase();
    widgets.add(ComptesCard(
        delete: delete,
        transaction: TransactionBud(
          categorie: null,
          montant: 24.99,
          date: DateTime.now(),
          nom: 'Orange',
          type: TypeTransaction.IMMEDIAT,
          compte: Compte(
              id: 997,
              solde: 1234,
              livret: Livret.livretA(),
              banque: 'BNP Paribas',
              color: Colors.blue,
              lastModification: DateTime.now()),
        )));
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
            if (value != null) {
              await databaseBud.insertCompte(value);
              refresh();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomMainPage(
        children: widgets,
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  initDatabase() async {
    databaseBud = DatabaseBud();
    await databaseBud.initDone;
    await refresh();
  }

  refresh() async {
    widgets = [];
    List<Compte> comptes = await databaseBud.getAllComptes();
    comptes.forEach((element) {
      widgets.add(ComptesCard(
          delete: delete,
          transaction: TransactionBud(
            compte: element,
          )));
    });
    print('dddddd');
    print(comptes);
    setState(() {
      print('setState');
    });
  }

  void delete(int id) async {
    await databaseBud.deleteCompte(id);
    await refresh();
  }
}
