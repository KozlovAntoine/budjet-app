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
      onTap: () {
        print('lala');
        print('Categorie card: $categorie');
      },
      modify: () {
        print('modify this $categorie');
      },
      delete: () {
        print('delete this $categorie');
      },
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
          SizedBox(height: 5),
          _progressBar(),
        ],
      ),
    );
  }

  _progressBar() {
    if (pourcentage <= 100) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: pourcentage.toInt(),
            child: Container(
              height: 4.0,
              color: Color.fromRGBO(pourcentage > 70 ? 255 : 0,
                  255 - (255 * (pourcentage / 100)).toInt(), 0, 1),
            ),
          ),
          Expanded(
            flex: 100 - pourcentage.toInt(),
            child: Container(
              height: 4.0,
              color: Colors.grey[300],
            ),
          ),
        ],
      );
    } else {
      return Container(
        height: 4.0,
        color: Colors.red,
      );
    }
  }
}
