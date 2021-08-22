import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:flutter/material.dart';

class VirementCard extends StatelessWidget {
  final Virement virement;

  VirementCard({required this.virement});

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
              _centeredText('Virement de 100.00€'),
              _bankInfo(virement.depuis),
              _transfertInfo(virement.depuis,
                  -virement.montant), //replace -100 by -map['montant']
              //ancienSolde1 -> nouveauSolde1
              _centeredText('Vers'),
              _bankInfo(virement.vers),
              _transfertInfo(virement.vers,
                  virement.montant), //ancienSolde2 -> nouveauSolde2
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Container()),
                  Text(
                    'le 27/06/2021',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
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
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
