import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/pages/views/cards/ComptesCard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PageCompte extends StatefulWidget {
  //PageCompte({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  _MesComptesPageState createState() => _MesComptesPageState();
}

class _MesComptesPageState extends State<PageCompte> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      body: GestureDetector(
        onHorizontalDragUpdate: (event) {
          if (event.delta.dx > 0) _scaffoldKey.currentState!.openDrawer();
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          children: [
            ComptesCard(const {
              'solde': 1465.58,
              'nom': 'Compte Courant',
              'banque': 'BNP Paribas',
              'categorie': 'Orange',
              'infoIcon': Icons.phone,
              'date': 'le 27/06/2021',
              'montant': -20.00,
            }, Colors.blue),
            ComptesCard(const {
              'solde': 9786.43,
              'nom': 'Livret A',
              'banque': 'BNP Paribas',
              'categorie': 'Virement',
              'infoIcon': Icons.euro,
              'date': 'le 12/06/2021',
              'montant': 100.00,
            }, Colors.orange),
            ComptesCard(const {
              'solde': 2150.00,
              'nom': 'LDDS',
              'banque': 'Caisse d\'Epargne',
              'categorie': 'Virement',
              'infoIcon': Icons.euro,
              'date': 'le 01/06/2021',
              'montant': 200.00,
            }, Colors.green),
            _addCard(),
          ],
        ),
      ),
    );
  }

  _addCard() {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 120,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(5),
          color: Theme.of(context).primaryColor,
          dashPattern: [4, 8],
          strokeWidth: 2,
          child: Center(
            child: Icon(
              Icons.add_circle,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
