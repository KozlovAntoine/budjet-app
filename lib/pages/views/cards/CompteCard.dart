import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComptesCard extends StatelessWidget {
  final Compte compte;
  final Transaction transaction;
  ComptesCard({required this.compte, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        //Container that does the shadow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
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
                      color: compte.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        compte.solde.toStringAsFixed(2) + '€',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                      SizedBox(height: 3),
                      Text(
                        compte.nom.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 3),
                      Text(
                        compte.banque.toString(),
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
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      transaction.categorie.icon,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      children: [
                        Text(transaction.categorie.nom.toString(),
                            style: TextStyle(fontSize: 18)),
                        Text(
                            "le " +
                                DateFormat('dd-MM-yyyy')
                                    .format(transaction.date),
                            style: TextStyle(fontSize: 13)),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Text(
                    transaction.montant.toStringAsFixed(2) + '€',
                    style: TextStyle(
                        fontSize: 18,
                        color: transaction.montant > 0
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
