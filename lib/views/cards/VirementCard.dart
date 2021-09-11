import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VirementCard extends StatelessWidget {
  final Virement virement;

  VirementCard({required this.virement});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        print('lala');
      },
      modify: () {
        print('modify this ${virement.toString()}');
      },
      delete: () {
        print('delete this ${virement.toString()}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          /**
          * Informations du haut
          */
          _centeredText(
              'Virement de ' + virement.montant.toStringAsFixed(2) + '€'),
          _bankInfo(virement.depuis),
          _transfertInfo(virement.depuis, -virement.montant),
          _centeredText('Vers'),
          /**
          * Informations du bas
          */
          _bankInfo(virement.vers),
          _transfertInfo(virement.vers, virement.montant),
          /**
          * Date
          */
          Row(
            children: [
              Spacer(),
              Text(
                'le ' + DateFormat('dd-MM-yyyy').format(virement.date),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _bankInfo(Compte compte) {
    return Row(
      children: [
        Container(
          //Cercle
          width: 70,
          height: 70,
          decoration: new BoxDecoration(
            color: compte.color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              compte.livret.name,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              compte.banque,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  _transfertInfo(Compte compte, double montant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          compte.solde.toStringAsFixed(2) + '€',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Icon(
          Icons.arrow_right_alt,
          size: 40,
        ),
        Text(
          (compte.solde + montant).toStringAsFixed(2) + '€',
          style: TextStyle(
            color: Colors.green,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  _centeredText(String txt) {
    return Center(
      child: Text(
        txt,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
