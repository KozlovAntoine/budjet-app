import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/TypeTransaction.dart';
import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:budjet_app/views/cards/DateCard.dart';
import 'package:flutter/material.dart';

class PageAddVirement extends StatefulWidget {
  final List<Compte> comptes;
  PageAddVirement({required this.comptes});
  @override
  _PageAddVirementState createState() => _PageAddVirementState();
}

class _PageAddVirementState extends State<PageAddVirement> {
  final _formKey = GlobalKey<FormState>();
  final montant = TextEditingController();
  late Compte expediteur;
  late Compte receveur;
  TypeTransaction type = TypeTransaction.IMMEDIAT;
  double montantTransfert = 0;
  late DateTime initial, end;

  @override
  void initState() {
    super.initState();
    initial = DateTime.now();
    end = DateTime.now();
    expediteur = widget.comptes.first;
    receveur = widget.comptes.last;
    montant.addListener(() {
      try {
        double tmp = double.parse(montant.text);
        setState(() {
          montantTransfert = tmp;
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Ajout d'un virement",
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
                icon: Icons.arrow_circle_up,
                main: _expediteur(),
                context: context,
                height: 80,
              ),
              CustomAddCarteFieldWithEntry(
                  controller: montant,
                  hint: 'Montant du transfert, ex: 100.00€',
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
                icon: Icons.arrow_circle_down,
                main: _receveur(),
                context: context,
                height: 80,
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
                      Virement virement = Virement(
                          dateInitial: initial,
                          dateActuel: initial,
                          dateFin: type == TypeTransaction.PERMANANT &&
                                  end.isAfter(initial)
                              ? end
                              : initial,
                          depuis: expediteur,
                          vers: receveur,
                          montant: double.parse(montant.text),
                          type: type);
                      Navigator.of(context).pop(virement);
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

  _expediteur() {
    return DropdownButton<Compte>(
      isExpanded: true,
      value: expediteur,
      icon: const Icon(Icons.keyboard_arrow_left),
      iconSize: 40,
      iconEnabledColor: Theme.of(context).primaryColor,
      elevation: 16,
      itemHeight: 80,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(),
      onChanged: (newValue) {
        setState(() {
          if (newValue! != receveur)
            expediteur = newValue;
          else {
            receveur = expediteur;
            expediteur = newValue;
          }
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
                      (compte.soldeActuel - montantTransfert)
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

  _receveur() {
    return DropdownButton<Compte>(
      isExpanded: true,
      value: receveur,
      icon: const Icon(Icons.keyboard_arrow_left),
      iconSize: 40,
      iconEnabledColor: Theme.of(context).primaryColor,
      elevation: 16,
      itemHeight: 80,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(),
      onChanged: (newValue) {
        setState(() {
          if (newValue! != expediteur)
            receveur = newValue;
          else {
            expediteur = receveur;
            receveur = newValue;
          }
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
                      (compte.soldeActuel + montantTransfert)
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
