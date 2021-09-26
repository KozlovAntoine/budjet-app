import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/data/database_bud.dart';
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
  late DatabaseBud databaseBud;
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  initDatabase() async {
    databaseBud = DatabaseBud();
    await databaseBud.initDone;
    await refresh();
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
            if (value != null) {
              await databaseBud.insertCategorie(value);
              refresh();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomMainPage(
        children: widgets,
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  refresh() async {
    widgets = [];
    List<Categorie> categories = await databaseBud.getAllCategories();
    categories.forEach((element) {
      widgets.add(CategorieCard(categorie: element, pourcentage: 1));
    });
    print('dddddd');
    print(categories);
    setState(() {
      print('setState');
    });
  }
}
