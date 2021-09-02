import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  CustomCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        //Container qui fait l'ombre
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: 5,
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomAddCarte extends StatelessWidget {
  final IconData icon;
  final Widget main;
  final BuildContext context;
  final double? height;
  CustomAddCarte(
      {required this.icon,
      required this.main,
      required this.context,
      this.height});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: height,
        padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
        child: Row(
          children: [
            _prefixeIcon(icon),
            SizedBox(width: 10),
            Container(
              height: height != null ? height : 40,
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

  _prefixeIcon(IconData icon) {
    return Icon(
      icon,
      size: 40,
      color: Theme.of(context).primaryColor,
    );
  }
}

class CustomAddCarteTextBothSide extends CustomAddCarte {
  final String text1;
  final String text2;
  final context;
  final icon;
  CustomAddCarteTextBothSide({
    required this.context,
    required this.icon,
    required this.text1,
    required this.text2,
  }) : super(
          context: context,
          icon: icon,
          main: Row(
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
          ),
        );
}

class CustomAddCarteFieldWithEntry extends CustomAddCarte {
  final controller;
  final hint;
  final keyboard;
  final validator;
  final icon;
  final context;

  CustomAddCarteFieldWithEntry(
      {required this.controller,
      required this.hint,
      required this.keyboard,
      required this.validator,
      required this.context,
      required this.icon})
      : super(
          context: context,
          icon: icon,
          main: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
            ),
            keyboardType: keyboard,
            validator: validator,
          ),
        );
}
