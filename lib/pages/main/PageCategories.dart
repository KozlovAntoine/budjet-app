import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/pages/add/PageAddCategorie.dart';
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
  void initState() {
    super.initState();
    print('init state');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PageAddCategorie()))
              .then((value) {
            if (value != null) {}
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomMainPage(
        children: [
          CategorieCard(
              categorie: Categorie(
                  color: Colors.green,
                  icon: Icons.phone,
                  nom: "Téléphonie",
                  plafond: 20),
              pourcentage: 100),
          CategorieCard(
              categorie: Categorie(
                  color: Colors.blue,
                  icon: Icons.account_balance,
                  nom: "Courses",
                  plafond: 300),
              pourcentage: 75),
          CategorieCard(
              categorie: Categorie(
                  color: Colors.red,
                  icon: Icons.air,
                  nom: "Voyage",
                  plafond: 500),
              pourcentage: 20),
        ],
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}
