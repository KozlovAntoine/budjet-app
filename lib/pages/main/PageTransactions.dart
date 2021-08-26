import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/TransactionCard.dart';
import 'package:flutter/material.dart';

class PageTransaction extends StatefulWidget {
  _PageTransactionState createState() => _PageTransactionState();
}

class _PageTransactionState extends State<PageTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        children: [
          TransactionCard(
            compte: Compte(
                solde: 1234,
                livret: Livret.livretA(),
                banque: 'BNP Paribas',
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
          )
        ],
      ),
    );
  }
}
