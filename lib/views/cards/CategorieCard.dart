import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';

class CategorieCard extends StatelessWidget {
  final Categorie categorie;
  final double pourcentage;
  CategorieCard({required this.categorie, required this.pourcentage});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: new BoxDecoration(
                  color: categorie.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  categorie.icon,
                  size: 40,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    categorie.nom,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  SizedBox(height: 3),
                  Text(
                      'Plafond mensuel : ' +
                          categorie.plafond.toStringAsFixed(2) +
                          '€',
                      style: TextStyle(fontSize: 18, color: Colors.black54)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Text(pourcentage.toStringAsFixed(0) + '%'),
              Spacer(),
            ],
          ),
          Container(
            height: 2.0,
            width: MediaQuery.of(context).size.width * 0.54,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
