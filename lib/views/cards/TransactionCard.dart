import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Compte compte;
  final Transaction transaction;

  TransactionCard({
    required this.transaction,
    required this.compte,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        //Container that does the shadow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                //the top of the card
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: new BoxDecoration(
                      color: transaction.categorie.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      transaction.categorie.icon,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        transaction.montant.toStringAsFixed(2) + '€',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                      SizedBox(height: 3),
                      Text(
                        transaction.nom.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 3),
                      Text(
                        transaction.categorie.nom.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.black,
                height: 2.0,
              ),
              SizedBox(height: 5),
              Row(
                //the bottom of the card
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: new BoxDecoration(
                      color: compte.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      children: [
                        Text(compte.livret.name,
                            style: TextStyle(fontSize: 18)),
                        Text(compte.banque, style: TextStyle(fontSize: 13)),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Text(
                      "le " + DateFormat('dd-MM-yyyy').format(transaction.date),
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
