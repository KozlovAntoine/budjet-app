import 'package:budjet_app/pages/views/PageCompte.dart';
import 'package:budjet_app/pages/views/PageVirement.dart';
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
            title: Text("Comptes"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PageCompte(),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.apps,
              color: iconColor,
            ),
            title: Text("Categories"),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
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
          ListTile(
            leading: Icon(
              Icons.compare_arrows,
              color: iconColor,
            ),
            title: Text("Transactions"),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
