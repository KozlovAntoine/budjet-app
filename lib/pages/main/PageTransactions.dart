import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => PageAddTransaction()))
              .then((value) {
            if (value != null) {}
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomMainPage(
        children: [
          TransactionCard(
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
                  id: 998,
                  solde: 1234,
                  livret: Livret.livretA(),
                  banque: 'BNP Paribas',
                  color: Colors.blue,
                  lastModification: DateTime.now()),
            ),
          )
        ],
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}
