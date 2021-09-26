import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionBud transaction;

  TransactionCard({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        print('lala');
      },
      modify: () {
        print('modify this $transaction');
      },
      delete: () {
        print('delete this $transaction');
      },
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
                  color: transaction.categorie!.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transaction.categorie!.icon,
                  size: 40,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    transaction.montant!.toStringAsFixed(2) + '€',
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
                    transaction.categorie!.nom.toString(),
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
                  color: transaction.compte.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Text(transaction.compte.livret.name,
                        style: TextStyle(fontSize: 18)),
                    Text(transaction.compte.banque,
                        style: TextStyle(fontSize: 13)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Text("le " + DateFormat('dd-MM-yyyy').format(transaction.date!),
                  style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
