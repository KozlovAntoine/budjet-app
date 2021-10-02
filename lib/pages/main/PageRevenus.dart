import 'package:budjet_app/animation/snack.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Revenu.dart';
import 'package:budjet_app/convert/DateHelper.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/RevenuDAO.dart';
import 'package:budjet_app/pages/add/PageAddRevenu.dart';
import 'package:budjet_app/pages/menu/SideMenu.dart';
import 'package:budjet_app/views/cards/RevenuCard.dart';
import 'package:flutter/material.dart';

import 'BottomNav.dart';
import 'CustomMainPage.dart';

class PageRevenus extends StatefulWidget {
  _PageRevenusState createState() => _PageRevenusState();
}

class _PageRevenusState extends State<PageRevenus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool dbLoaded = false;
  late RevenuDAO dao;
  late CompteDAO compteDAO;
  List<RevenuCard> widgets = [];
  List<Compte> comptes = [];
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dao = RevenuDAO();
    compteDAO = CompteDAO();
    print('init');
    refresh();
  }

  @override
  void didUpdateWidget(covariant PageRevenus oldWidget) {
    dbLoaded = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Mes revenus",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        initialDate: DateTime.now(),
        changeDate: (date) {
          selectedDate = date;
          refresh();
        },
      ),
      floatingActionButton: comptes.isEmpty
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PageAddRevenu(
                              comptes: comptes,
                            )))
                    .then((value) async {
                  if (value != null && value is Revenu) {
                    print(value);
                    await insertAll(value);
                    refresh();
                  }
                });
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: dbLoaded
          ? CustomMainPage(
              children: widgets,
              scaffoldKey: _scaffoldKey,
              text: comptes.isEmpty ? 'Vous devez ajouter un compte.' : 'Vide',
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  refresh() async {
    widgets = [];
    List<Revenu> revenues = await dao.getAllFromDate(selectedDate);
    comptes = await compteDAO.getAll();
    for (var element in revenues) {
      widgets.add(RevenuCard(
        revenu: element,
        onDelete: delete,
      ));
    }
    print(revenues);
    setState(() {
      dbLoaded = true;
      print('setstate');
    });
  }

  void delete(Revenu r) async {
    await dao.delete(r);
    refresh();
  }

  Future<void> insertAll(Revenu t) async {
    DateTime tmp =
        DateTime(t.dateInitial.year, t.dateInitial.month, t.dateInitial.day);
    while (!tmp.isAfter(t.dateFin)) {
      Revenu r = Revenu(
          color: t.color,
          compte: t.compte,
          montant: t.montant,
          nom: t.nom,
          type: t.type,
          id: t.id,
          dateInitial: t.dateInitial,
          dateFin: t.dateFin,
          dateActuel: tmp);
      await dao.insert(r);
      //on ajoute un mois
      tmp = DateHelper.ajoutMois(tmp);
    }
  }
}
