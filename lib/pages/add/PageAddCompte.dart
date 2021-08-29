import 'package:budjet_app/animation/snack.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  Color pickerColor = Color(Colors.blue.value);
  Color currentColor = Color(Colors.blue.value);
  bool isChanged = false;
  String lastTextSolde = "";

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    soldeController.addListener(() {
      print('call');
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
          key: _formKey,
          child: ListView(
            children: [
              _carte(
                Icons.account_balance_wallet,
                _fieldWithEntry(
                  soldeController,
                  "ex: 1234.56€",
                  TextInputType.numberWithOptions(decimal: true, signed: false),
                  (value) {
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
                ),
              ),
              _carte(
                Icons.account_balance,
                _fieldWithEntry(
                  banqueController,
                  "ex: BNP Paribas",
                  TextInputType.text,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez le nom de votre banque";
                    }
                    return null;
                  },
                ),
              ),
              _carte(
                Icons.assignment,
                _listeCompte(),
              ),
              _carte(
                Icons.vertical_align_top,
                _fieldWithTextBothSide(
                    "Plafond",
                    livretSelection.plafond != null
                        ? livretSelection.plafond!.toStringAsFixed(0) + "€"
                        : "Pas de plafond"),
              ),
              _carte(
                Icons.vertical_align_bottom,
                _fieldWithTextBothSide("Découvert autorisé",
                    livretSelection.decouvert ? "Oui" : "Non"),
              ),
              _carte(
                Icons.call_made,
                _fieldWithTextBothSide(
                    "Intérêt",
                    "Minimum " +
                        (livretSelection.interet * 100).toStringAsFixed(2) +
                        "%"),
              ),
              InkWell(
                child: _carte(
                  Icons.brush,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Couleur :",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: currentColor,
                            borderRadius: BorderRadius.circular(5)),
                        width: 100,
                        height: 35,
                      ),
                    ],
                  ),
                ),
                onTap: () => _colorPicker(),
              ),
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
                        color: currentColor);
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

  _prefixeIcon(IconData icon) {
    return Icon(
      icon,
      size: 40,
      color: Theme.of(context).primaryColor,
    );
  }

  _fieldWithEntry(TextEditingController controller, String hint,
      TextInputType keyboard, validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
      keyboardType: keyboard,
      validator: validator,
    );
  }

  _fieldWithTextBothSide(String text1, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1 + " :",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
        ),
        Text(
          text2,
          style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
        ),
      ],
    );
  }

  _carte(IconData icon, Widget main) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
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
            Expanded(child: main),
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
      ),
    );
  }

  _colorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Choisir une couleur',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _colorPickerAdvanced();
            },
            child: const Text('Avancé'),
          ),
          TextButton(
            child: const Text('OK!'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _colorPickerAdvanced() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Choisir une couleur',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
            colorPickerWidth: 400.0,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            displayThumbColor: true,
            showLabel: false,
            paletteType: PaletteType.hsv,
            pickerAreaBorderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(2.0),
              topRight: const Radius.circular(2.0),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _colorPicker();
            },
            child: const Text('Simple'),
          ),
          TextButton(
            child: const Text('OK!'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
