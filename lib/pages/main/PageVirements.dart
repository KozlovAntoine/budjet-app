import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/pages/add/PageAddVirement.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/VirementCard.dart';
import 'package:flutter/material.dart';

class PageVirement extends StatefulWidget {
  @override
  _PageVirementState createState() => _PageVirementState();
}

class _PageVirementState extends State<PageVirement> {
  List<VirementCard> cards = [
    VirementCard(
      virement: Virement(
        date: DateTime.now(),
        depuis: Compte(
            solde: 1234,
            livret: Livret.livretA(),
            banque: 'BNP Paribas',
            color: Colors.blue,
            lastModification: DateTime.now()),
        vers: Compte(
            solde: 9702,
            banque: 'BNP Paribas',
            livret: Livret.cel(),
            color: Colors.green,
            lastModification: DateTime.now()),
        montant: 200,
        type: TypeTransaction.IMMEDIAT,
      ),
    ),
  ];

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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PageAddVirement()))
              .then((value) {
            if (value != null) {
              cards.add(VirementCard(virement: value));
              setState(() {});
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomMainPage(
        children: cards,
        scaffoldKey: _scaffoldKey,
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
