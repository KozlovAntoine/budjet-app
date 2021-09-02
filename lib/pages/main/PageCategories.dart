import 'dart:math';

import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/pages/add/PageAddCategorie.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/CategorieCard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PageCategories extends StatefulWidget {
  @override
  _PageCategoriesState createState() => _PageCategoriesState();
}

class _PageCategoriesState extends State<PageCategories> {
  List<Widget> cards = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print('init state');
    cards.add(CategorieCard(
        categorie: Categorie(
            color: Colors.green,
            icon: Icons.phone,
            nom: "Téléphonie",
            plafond: 20),
        pourcentage: 60));
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes catégories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: CustomMainPage(
        children: List.from(cards)..add(_addCard()),
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  _addCard() {
    return InkWell(
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 100,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(5),
            color: Theme.of(context).primaryColor,
            dashPattern: [4, 8],
            strokeWidth: 2,
            child: Center(
              child: Icon(
                Icons.add_circle,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageAddCategorie()))
            .then((value) {
          print(value.toString());
          if (value != null) {
            print('AJOUT' + value.toString());
            cards.add(CategorieCard(
                categorie: value, pourcentage: Random().nextDouble() * 100));
            print('cards + ' + cards.length.toString());
            setState(() {});
          }
        });
      },
    );
  }
}
