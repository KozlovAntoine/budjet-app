import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:flutter/material.dart';

import '../views/cards/TransactionCard.dart';

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
        children: [
          TransactionCard(
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
          )
        ],
      ),
    );
  }
}
