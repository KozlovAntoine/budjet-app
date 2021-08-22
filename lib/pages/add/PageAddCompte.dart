import 'package:budjet_app/animation/snack.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:flutter/material.dart';

class PageAddCompte extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageAddCompteState();
  }
}

class PageAddCompteState extends State<PageAddCompte> {
  final _formKey = GlobalKey<FormState>();
  final banqueController = TextEditingController();
  final compteController = TextEditingController();
  Livret livretSelection = Livret.allLivrets.first;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    banqueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Ajout compte",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _carte(
                Icons.assignment,
                Expanded(
                  child: _listeCompte(),
                ),
              ),
              SizedBox(height: 8),
              _carte(
                Icons.business,
                Expanded(
                  child: TextFormField(
                    controller: banqueController,
                    decoration: InputDecoration(
                      hintText: 'ex: BNP Paribas',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Snack(context, livretSelection.name);
                  },
                  child: Text('Enregistrer'))
            ],
          ),
        ),
      ),
    );
  }

  _listeCompte() {
    return DropdownButton<Livret>(
      isExpanded: true,
      value: livretSelection,
      icon: const Icon(Icons.keyboard_arrow_left),
      iconSize: 40,
      iconEnabledColor: Theme.of(context).primaryColor,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(),
      onChanged: (newValue) {
        setState(() {
          livretSelection = newValue!;
        });
      },
      items: Livret.allLivrets.map<DropdownMenuItem<Livret>>((livret) {
        return DropdownMenuItem<Livret>(
          value: livret,
          child: Text(livret.name),
        );
      }).toList(),
      dropdownColor: Colors.white,
    );
  }

  _prefixeIcon(IconData icon) {
    return Icon(
      icon,
      size: 40,
      color: Theme.of(context).primaryColor,
    );
  }

  _carte(IconData icon, Widget main) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
      child: Row(
        children: [
          _prefixeIcon(icon),
          SizedBox(width: 10),
          Container(
            height: 40,
            width: 1,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          main,
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
