import 'package:flutter/material.dart';

class Snack {
  Snack(context, text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
