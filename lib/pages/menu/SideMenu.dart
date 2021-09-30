import 'package:budjet_app/pages/main/PageCategories.dart';
import 'package:budjet_app/pages/main/PageComptes.dart';
import 'package:budjet_app/pages/main/PageRevenus.dart';
import 'package:budjet_app/pages/main/PageTransactions.dart';
import 'package:budjet_app/pages/main/PageVirements.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).primaryColor;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(
              Icons.account_balance,
              color: iconColor,
            ),
            title: Text(
              "Comptes",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PageCompte(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.apps,
              color: iconColor,
            ),
            title: Text("Categories"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PageCategories(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.compare_arrows,
              color: iconColor,
            ),
            title: Text("Revenus"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PageRevenus(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.euro,
              color: iconColor,
            ),
            title: Text("Virements"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PageVirement(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.compare_arrows,
              color: iconColor,
            ),
            title: Text("Transactions"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PageTransaction(),
              ));
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
