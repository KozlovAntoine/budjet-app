import 'package:budjet_app/animation/ColorPick.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
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
  final soldeController = TextEditingController();
  Livret livretSelection = Livret.allLivrets.first;
  Color currentColor = Color(Colors.blue.value);
  bool isChanged = false;
  String lastTextSolde = "";

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    soldeController.addListener(() {
      if (soldeController.text.contains(' ') ||
          soldeController.text.contains(',')) {
        //enleve ' ' et ',' pour eviter les erreurs pour parser
        String tmp = soldeController.text;
        tmp = tmp.replaceAll(RegExp(r','), '.');
        tmp = tmp.replaceAll(RegExp(r' '), '');
        soldeController.text = tmp;
        soldeController.selection = TextSelection.fromPosition(
            TextPosition(offset: soldeController.text.length));
      } else if ('.'.allMatches(soldeController.text).length > 1) {
        // ex: 13..35 -> 13.35
        soldeController.text = soldeController.text
            .replaceRange(soldeController.text.length - 1, null, '');
        soldeController.selection = TextSelection.fromPosition(
            TextPosition(offset: soldeController.text.length));
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    soldeController.dispose();
    banqueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Ajout d'un compte",
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
          key: _formKey,
          child: ListView(
            children: [
              CustomAddCarteFieldWithEntry(
                icon: Icons.account_balance_wallet,
                controller: soldeController,
                hint: "Votre solde actuel, ex: 1234.56€",
                keyboard: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez votre solde actuel";
                  }
                  try {
                    double.parse(soldeController.text);
                  } catch (error) {
                    return 'Vérifiez votre entrée';
                  }
                  return null;
                },
                context: context,
              ),
              CustomAddCarteFieldWithEntry(
                icon: Icons.account_balance,
                controller: banqueController,
                hint: "Votre nom de banque, ex: BNP Paribas",
                keyboard: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez le nom de votre banque";
                  }
                  return null;
                },
                context: context,
              ),
              CustomAddCarte(
                icon: Icons.assignment,
                main: _listeCompte(),
                context: context,
              ),
              CustomAddCarteTextBothSide(
                icon: Icons.vertical_align_top,
                text1: "Plafond",
                text2: livretSelection.plafond != null
                    ? livretSelection.plafond!.toStringAsFixed(0) + "€"
                    : "Pas de plafond",
                context: context,
              ),
              CustomAddCarteTextBothSide(
                icon: Icons.vertical_align_bottom,
                text1: "Découvert autorisé",
                text2: livretSelection.decouvert ? "Oui" : "Non",
                context: context,
              ),
              CustomAddCarteTextBothSide(
                icon: Icons.call_made,
                text1: "Intérêt",
                text2: "Minimum " +
                    (livretSelection.interet * 100).toStringAsFixed(2) +
                    "%",
                context: context,
              ),
              ColorPick(onChange: changeColor),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    print(soldeController.text);
                    Compte compte = Compte(
                        solde: double.parse(soldeController.text),
                        livret: livretSelection,
                        banque: banqueController.text,
                        color: currentColor,
                        lastModification: DateTime.now());
                    Navigator.of(context).pop(compte);
                  }
                },
                child: Text('Enregistrer'),
              ),
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
}
