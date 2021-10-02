import 'package:budjet_app/classes/Revenu.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenuCard extends StatelessWidget {
  final Revenu revenu;
  final Function onDelete;
  RevenuCard({required this.revenu, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        print('lala');
      },
      modify: () {
        print('modify this $revenu');
      },
      delete: () {
        onDelete(revenu);
        print('delete this $revenu');
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
                  color: revenu.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    revenu.montant.toStringAsFixed(2) + '€',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  SizedBox(height: 3),
                  Text(
                    revenu.nom.toString(),
                    style: TextStyle(fontSize: 20),
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
                  color: revenu.compte.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Text(revenu.compte.livret.name,
                        style: TextStyle(fontSize: 18)),
                    Text(revenu.compte.banque, style: TextStyle(fontSize: 13)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Text("le " + DateFormat('dd/MM/yyyy').format(revenu.dateActuel),
                  style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
