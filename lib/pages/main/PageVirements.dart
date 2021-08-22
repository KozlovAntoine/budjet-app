import 'package:budjet_app/animation/snack.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/pages/views/cards/VirementCard.dart';
import 'package:flutter/material.dart';

class PageVirement extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes virements",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Snack(context, 'Ajout');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (event) {
          if (event.delta.dx > 0) _scaffoldKey.currentState!.openDrawer();
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          children: [
            VirementCard(
              virement: Virement(
                date: DateTime.now(),
                depuis: Compte(
                    solde: 1234,
                    nom: 'Compte courant',
                    banque: 'BNP Paribas',
                    plafond: 22950,
                    decouvretAutorise: 0,
                    interet: 0.75,
                    color: Colors.blue),
                vers: Compte(
                    solde: 9702,
                    nom: 'Compte courant',
                    banque: 'BNP Paribas',
                    plafond: 22950,
                    decouvretAutorise: 0,
                    interet: 0.75,
                    color: Colors.blue),
                montant: 200,
              ),
            ),
            separator('Juillet', '2021'),
          ],
        ),
      ),
    );
  }

  separator(mois, annee) {
    const spaceHeight = 5.0;
    const spaceWidth = 15.0;
    return Column(
      children: [
        SizedBox(height: spaceHeight),
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.black, height: 4),
            ),
            SizedBox(width: spaceWidth),
            Text(
              mois + ' ' + annee,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: spaceWidth),
            Expanded(
              child: Divider(color: Colors.black, height: 4),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        SizedBox(height: spaceHeight),
      ],
    );
  }
}
