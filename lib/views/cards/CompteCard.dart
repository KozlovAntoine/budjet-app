import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';

class ComptesCard extends StatelessWidget {
  final Compte compte;
  final Function onDelete;
  final double entree;
  final double sortie;
  final double finDuMois;
  ComptesCard(
      {required this.compte,
      required this.onDelete,
      required this.entree,
      required this.sortie,
      required this.finDuMois});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        print('lala');
      },
      modify: () {},
      delete: () {
        onDelete(compte);
      },
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
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
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    compte.soldeActuel.toStringAsFixed(2) + '€',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  SizedBox(height: 3),
                  Text(
                    compte.livret.name,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 3),
                  Text(
                    compte.banque,
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
          //BOTTOM OF THE CARD
          Row(
            children: [
              Text('+${entree.toStringAsFixed(2)}€',
                  style: TextStyle(color: Colors.green)),
              Text('/'),
              Text('-${sortie.toStringAsFixed(2)}€',
                  style: TextStyle(color: Colors.red)),
              Spacer(),
              Row(
                children: [
                  Text('Prévision : '),
                  Text('${finDuMois.toStringAsFixed(2)}€',
                      style: TextStyle(
                          color: finDuMois < 0 ? Colors.red : Colors.green))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
