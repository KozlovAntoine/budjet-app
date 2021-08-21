import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/pages/views/cards/CategorieCard.dart';
import 'package:flutter/material.dart';

class PageCategories extends StatefulWidget {
  @override
  _PageCategoriesState createState() => _PageCategoriesState();
}

class _PageCategoriesState extends State<PageCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView(
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
      ),
    );
  }
}
