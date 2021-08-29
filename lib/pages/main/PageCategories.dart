import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/pages/main/CustomMainPage.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/CategorieCard.dart';
import 'package:flutter/material.dart';

class PageCategories extends StatefulWidget {
  @override
  _PageCategoriesState createState() => _PageCategoriesState();
}

class _PageCategoriesState extends State<PageCategories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
        children: [
          CategorieCard(
            categorie: Categorie(
                nom: 'Téléphonie',
                color: Colors.orange,
                icon: Icons.phone,
                plafond: 25),
            pourcentage: 60,
          )
        ],
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}
