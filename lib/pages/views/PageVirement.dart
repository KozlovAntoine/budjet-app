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
      body: GestureDetector(
        onHorizontalDragUpdate: (event) {
          if (event.delta.dx > 0) _scaffoldKey.currentState!.openDrawer();
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          children: [
            VirementCard({
              'compte1': 'Compte Courant',
              'compte2': 'Livret A',
              'color1': Colors.blue,
              'color2': Colors.orange,
              'nom1': 'BNP Paribas',
              'nom2': 'BNP Paribas',
              'ancienSolde1': 1457.37,
              'ancienSolde2': 9786.43,
              'montant': 100.00
            }),
            VirementCard({
              'compte1': 'LDDS',
              'compte2': 'Livret A',
              'color1': Colors.green,
              'color2': Colors.orange,
              'nom1': 'BNP Paribas',
              'nom2': 'BNP Paribas',
              'ancienSolde1': 2150.00,
              'ancienSolde2': 9786.43,
              'montant': 150.00
            }),
          ],
        ),
      ),
    );
  }

  separator() {
    return Row();
  }
}
