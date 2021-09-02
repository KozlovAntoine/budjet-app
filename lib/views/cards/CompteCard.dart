import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComptesCard extends StatelessWidget {
  final Transaction transaction;
  ComptesCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
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
                  color: transaction.compte.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    transaction.compte.solde.toStringAsFixed(2) + '€',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  SizedBox(height: 3),
                  Text(
                    transaction.compte.livret.name,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 3),
                  Text(
                    transaction.compte.banque,
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
                            DateFormat('dd-MM-yyyy').format(transaction.date),
                        style: TextStyle(fontSize: 13)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Text(
                transaction.montant.toStringAsFixed(2) + '€',
                style: TextStyle(
                    fontSize: 18,
                    color: transaction.montant > 0 ? Colors.green : Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
