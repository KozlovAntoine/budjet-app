import 'package:budjet_app/animation/ColorPick.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Revenu.dart';
import 'package:budjet_app/classes/TypeTransaction.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:budjet_app/views/cards/DateCard.dart';
import 'package:flutter/material.dart';

class PageAddRevenu extends StatefulWidget {
  final List<Compte> comptes;

  PageAddRevenu({required this.comptes});

  _PageAddRevenuState createState() => _PageAddRevenuState();
}

class _PageAddRevenuState extends State<PageAddRevenu> {
  final _formKey = GlobalKey<FormState>();
  final montant = TextEditingController();
  final name = TextEditingController();
  late Compte compteSelection;
  Color currentColor = Color(Colors.blue.value);
  double nouveauSolde = 0;
  late DateTime initial, end;

  @override
  void initState() {
    super.initState();
    initial = DateTime.now();
    end = DateTime.now();
    compteSelection = widget.comptes.first;
    nouveauSolde = compteSelection.soldeActuel;
    montant.addListener(() {
      try {
        double tmp = double.parse(montant.text);
        setState(() {
          nouveauSolde = compteSelection.soldeActuel + tmp;
        });
      } on Exception {
        print('error');
      }
    });
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  void changerInitial(DateTime time) {
    this.initial = time;
    print('changement initial $initial');
  }

  void changerEnd(DateTime time) {
    this.end = time;
    print('changement end $end');
  }

  TypeTransaction type = TypeTransaction.IMMEDIAT;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Ajout d'un revenu",
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
                icon: Icons.drive_file_rename_outline,
                controller: name,
                hint: "Nom, ex: Travail...",
                keyboard: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez le nom de votre revenu";
                  }
                  return null;
                },
                context: context,
              ),
              CustomAddCarteFieldWithEntry(
                  controller: montant,
                  hint: 'Montant du revenu, ex: 100.00€',
                  keyboard: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre solde actuel";
                    }
                    try {
                      double.parse(montant.text);
                    } catch (error) {
                      return 'Vérifiez votre entrée';
                    }
                    return null;
                  },
                  context: context,
                  icon: Icons.euro),
              CustomAddCarte(
                icon: Icons.account_balance,
                main: _listeCompte(),
                context: context,
              ),
              CustomAddCarte(
                icon: Icons.access_time,
                main: _typeVirement(),
                context: context,
              ),
              _selectionDate(),
              ColorPick(onChange: changeColor),
              ButtonEnregister(
                widget: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Revenu revenu = Revenu(
                        montant: double.parse(montant.text),
                        nom: name.text,
                        dateInitial: initial,
                        dateActuel: initial,
                        dateFin: type == TypeTransaction.PERMANANT &&
                                end.isAfter(initial)
                            ? end
                            : initial,
                        type: type,
                        compte: compteSelection,
                        color: currentColor,
                      );
                      Navigator.of(context).pop(revenu);
                    }
                  },
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listeCompte() {
    return DropdownButton<Compte>(
      isExpanded: true,
      value: compteSelection,
      icon: const Icon(Icons.keyboard_arrow_left),
      iconSize: 40,
      iconEnabledColor: Theme.of(context).primaryColor,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(),
      itemHeight: 80,
      onChanged: (newValue) {
        setState(() {
          compteSelection = newValue!;
        });
      },
      items: widget.comptes.map<DropdownMenuItem<Compte>>((compte) {
        return DropdownMenuItem<Compte>(
          value: compte,
          child: Container(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(compte.livret.name),
                Spacer(),
                Text(
                  'Solde actuel : ' +
                      compte.soldeActuel.toStringAsFixed(2) +
                      '€',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Spacer(),
                Text(
                  'Nouveau solde : ' + nouveauSolde.toStringAsFixed(2) + '€',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      dropdownColor: Colors.white,
    );
  }

  _typeVirement() {
    return DropdownButton<TypeTransaction>(
      isExpanded: true,
      value: type,
      icon: const Icon(Icons.keyboard_arrow_left),
      iconSize: 40,
      iconEnabledColor: Theme.of(context).primaryColor,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(),
      onChanged: (newValue) {
        setState(() {
          type = newValue!;
        });
      },
      items: TypeTransaction.values.map<DropdownMenuItem<TypeTransaction>>((t) {
        return DropdownMenuItem<TypeTransaction>(
          value: t,
          child: Text(TypeTransactionHelper.typeToString(t)),
        );
      }).toList(),
      dropdownColor: Colors.white,
    );
  }

  _selectionDate() {
    if (type == TypeTransaction.PERMANANT) {
      return DateCard(
        changeInitialDate: changerInitial,
        changeEndDate: changerEnd,
        afficherEnd: true,
        init: initial,
      );
    } else if (type == TypeTransaction.DIFFERE) {
      return DateCard(
        changeInitialDate: changerInitial,
        changeEndDate: changerEnd,
        afficherEnd: false,
        init: initial,
      );
    } else {
      initial = DateTime.now();
      return Container();
    }
  }
}
