import 'package:budjet_app/animation/ColorPick.dart';
import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class PageAddCategorie extends StatefulWidget {
  _PageAddCategorieState createState() => _PageAddCategorieState();
}

class _PageAddCategorieState extends State<PageAddCategorie> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final plafond = TextEditingController();
  IconData _icon = Icons.phone;

  Color currentColor = Color(Colors.blue.value);

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    plafond.addListener(() {
      if (plafond.text.contains('-') ||
          plafond.text.contains(' ') ||
          plafond.text.contains(',')) {
        //enleve ' ' et ',' pour eviter les erreurs pour parser
        String tmp = plafond.text;
        tmp = tmp.replaceAll(RegExp(r','), '.');
        tmp = tmp.replaceAll(RegExp(r' '), '');
        tmp = tmp.replaceAll(RegExp(r'-'), '');
        plafond.text = tmp;
        plafond.selection = TextSelection.fromPosition(
            TextPosition(offset: plafond.text.length));
      } else if ('.'.allMatches(plafond.text).length > 1) {
        // ex: 13..35 -> 13.35
        plafond.text =
            plafond.text.replaceRange(plafond.text.length - 1, null, '');
        plafond.selection = TextSelection.fromPosition(
            TextPosition(offset: plafond.text.length));
      }
    });
  }

  @override
  void dispose() {
    name.dispose();
    plafond.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Ajout d'une catégorie",
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
                  controller: name,
                  hint: 'Nom de la catégorie, ex: Magasin',
                  keyboard: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Entrez un nom';
                    return null;
                  },
                  context: context,
                  icon: Icons.drive_file_rename_outline),
              CustomAddCarteFieldWithEntry(
                  controller: plafond,
                  hint: 'Plafond mensuel, ex: 50.00€',
                  keyboard: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre solde actuel";
                    }
                    try {
                      double.parse(plafond.text);
                    } catch (error) {
                      return 'Vérifiez votre entrée';
                    }
                    return null;
                  },
                  context: context,
                  icon: Icons.vertical_align_top),
              ColorPick(onChange: changeColor),
              CustomAddCarte(
                  icon: Icons.auto_fix_high,
                  main: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      child: Row(
                        children: [
                          Text('Icône :',
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 20)),
                          Spacer(),
                          Icon(_icon, size: 30),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                    onTap: () => _pickIcon(),
                  ),
                  context: context),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Categorie categorie = Categorie(
                      nom: name.text,
                      plafond: double.parse(plafond.text),
                      color: currentColor,
                      icon: _icon,
                    );
                    Navigator.of(context).pop(categorie);
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

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackMode: IconPack.material);
    if (icon != null) {
      _icon = icon;
      setState(() {});
    }

    debugPrint('Picked Icon:  $icon');
  }
}
