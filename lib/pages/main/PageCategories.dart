import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
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
  List<Widget> widgets = [];
  late CategorieDAO dao;
  bool categorieLoaded = false;

  @override
  void initState() {
    super.initState();
    dao = CategorieDAO();
    categorieLoaded = false;
    refresh();
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
              .then((value) async {
            if (value != null && value is Categorie) {
              await dao.insert(value);
              await refresh();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: categorieLoaded
          ? CustomMainPage(
              children: widgets,
              scaffoldKey: _scaffoldKey,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  refresh() async {
    widgets = [];
    List<Categorie> categories = await dao.getAll();
    categories.forEach((element) {
      widgets.add(CategorieCard(categorie: element, pourcentage: 1));
    });
    print('dddddd');
    print(categories);
    setState(() {
      categorieLoaded = true;
      print('setState');
    });
  }
}
