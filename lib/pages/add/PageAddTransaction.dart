import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/classes/TypeTransaction.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:budjet_app/views/cards/DateCard.dart';
import 'package:flutter/material.dart';

class PageAddTransaction extends StatefulWidget {
  final List<Compte> comptes;
  final List<Categorie> categories;
  PageAddTransaction({required this.comptes, required this.categories});
  _PageAddTransactionState createState() => _PageAddTransactionState();
}

class _PageAddTransactionState extends State<PageAddTransaction> {
  final _formKey = GlobalKey<FormState>();
  final montant = TextEditingController();
  final name = TextEditingController();
  late Compte compteSelection;
  late Categorie categorieSelection;
  TypeTransaction type = TypeTransaction.IMMEDIAT;
  double montantTransaction = 0;
  late DateTime initial, end;

  @override
  void initState() {
    super.initState();
    initial = DateTime.now();
    end = DateTime.now();
    categorieSelection = widget.categories.first;
    compteSelection = widget.comptes.first;
    montant.addListener(() {
      try {
        double tmp = double.parse(montant.text);
        setState(() {
          montantTransaction = tmp;
        });
      } on Exception {
        print('error');
      }
    });
  }

  void changerInitial(DateTime time) {
    this.initial = time;
    print('changement initial $initial');
  }

  void changerEnd(DateTime time) {
    this.end = time;
    print('changement end $end');
  }

  @override
  Widget build(BuildContext context) {
    print('------------------------------------------------------------');
    print('BUILD initial $initial');
    print('BUILD end $end');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Ajout d'une transaction",
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
              CustomAddCarte(
                icon: Icons.account_balance,
                main: _listeCompte(),
                context: context,
                height: 80,
              ),
              CustomAddCarteFieldWithEntry(
                icon: Icons.drive_file_rename_outline,
                controller: name,
                hint: "Nom, ex: Courses chez...",
                keyboard: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez le nom de votre transaction";
                  }
                  return null;
                },
                context: context,
              ),
              CustomAddCarteFieldWithEntry(
                  controller: montant,
                  hint: 'Montant du transfert, ex: 100.00€',
                  keyboard: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez le montant du transfert";
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
                icon: Icons.apps,
                main: _listeCategorie(),
                context: context,
              ),
              CustomAddCarte(
                icon: Icons.access_time,
                main: _typeVirement(),
                context: context,
              ),
              _selectionDate(),
              ButtonEnregister(
                widget: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('type $type');
                      print('initial $initial');
                      print('end $end');
                      TransactionBud transaction = TransactionBud(
                          montant: double.parse(montant.text),
                          nom: name.text,
                          categorie: categorieSelection,
                          dateInitial: initial,
                          dateActuel: initial,
                          dateFin: type == TypeTransaction.PERMANANT &&
                                  end.isAfter(initial)
                              ? end
                              : initial,
                          type: type,
                          compte: compteSelection);
                      Navigator.of(context).pop(transaction);
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
                  'Nouveau solde : ' +
                      (compte.soldeActuel - montantTransaction)
                          .toStringAsFixed(2) +
                      '€',
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

  _listeCategorie() {
    return DropdownButton<Categorie>(
      isExpanded: true,
      value: categorieSelection,
      icon: const Icon(Icons.keyboard_arrow_left),
      iconSize: 40,
      iconEnabledColor: Theme.of(context).primaryColor,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(),
      onChanged: (newValue) {
        setState(() {
          categorieSelection = newValue!;
        });
      },
      items: widget.categories.map<DropdownMenuItem<Categorie>>((categorie) {
        return DropdownMenuItem<Categorie>(
          value: categorie,
          child: Text(categorie.nom),
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
