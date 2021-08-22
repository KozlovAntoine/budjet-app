import 'package:budjet_app/animation/snack.dart';
import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/pages/add/PageAddCompte.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/pages/views/cards/CompteCard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PageCompte extends StatefulWidget {
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
            ComptesCard(
              compte: Compte(
                  solde: 1234,
                  nom: 'Compte courant',
                  banque: 'BNP Paribas',
                  plafond: 22950,
                  decouvretAutorise: 0,
                  interet: 0.75,
                  color: Colors.blue),
              transaction: Transaction(
                  categorie: Categorie(
                      nom: 'Téléphonie',
                      color: Colors.orange,
                      icon: Icons.phone,
                      plafond: 25),
                  montant: 24.99,
                  date: DateTime.now(),
                  nom: 'Orange',
                  type: TypeTransaction.IMMEDIAT),
            ),
            _addCard(),
          ],
        ),
      ),
    );
  }

  _addCard() {
    return InkWell(
      child: Card(
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
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (context) => PageAddCompte(),
            ))
            .then((value) => Snack(context, value.toString()));
      },
    );
  }
}
