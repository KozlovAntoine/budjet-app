import 'package:budjet_app/animation/snack.dart';
import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/pages/add/PageAddCompte.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/CompteCard.dart';
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
      body: CustomMainPage(
        children: [
          ComptesCard(
            transaction: Transaction(
              categorie: Categorie(
                  nom: 'Téléphonie',
                  color: Colors.orange,
                  icon: Icons.phone,
                  plafond: 25),
              montant: 24.99,
              date: DateTime.now(),
              nom: 'Orange',
              type: TypeTransaction.IMMEDIAT,
              compte: Compte(
                  solde: 1234,
                  livret: Livret.livretA(),
                  banque: 'BNP Paribas',
                  color: Colors.blue),
            ),
          ),
          _addCard(),
        ],
        scaffoldKey: _scaffoldKey,
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
            .push(MaterialPageRoute(builder: (context) => PageAddCompte()))
            .then((compte) {
          Snack(context, compte.toString());
          if (compte is Compte) {}
        });
      },
    );
  }
}
