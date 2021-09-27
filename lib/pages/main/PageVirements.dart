import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/dao/VirementDAO.dart';
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
  List<VirementCard> cards = [];
  List<Compte> comptes = [];
  late CompteDAO compteDAO;
  late VirementDAO dao;
  bool dbLoaded = false;

  @override
  void initState() {
    super.initState();
    dao = VirementDAO();
    compteDAO = CompteDAO();
    refresh();
  }

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
              .push(MaterialPageRoute(
                  builder: (context) => PageAddVirement(comptes: comptes)))
              .then((value) async {
            if (value != null && value is Virement) {
              await dao.insert(value);
              refresh();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: dbLoaded
          ? CustomMainPage(
              children: cards,
              scaffoldKey: _scaffoldKey,
            )
          : Center(
              child: CircularProgressIndicator(),
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

  refresh() async {
    List<Virement> virements = await dao.getAll();
    comptes = await compteDAO.getAll();
    virements.forEach((element) {
      cards.add(VirementCard(virement: element));
    });
    print(comptes);
    print(virements);
    setState(() {
      dbLoaded = true;
      print('setState');
    });
  }
}
