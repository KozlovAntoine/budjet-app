import 'package:budjet_app/views/cards/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPick extends StatefulWidget {
  final Function onChange;
  ColorPick({required this.onChange});
  @override
  State<StatefulWidget> createState() {
    return _ColorPickState();
  }
}

class _ColorPickState extends State<ColorPick> {
  Color pickerColor = Color(Colors.blue.value);
  Color currentColor = Color(Colors.blue.value);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    widget.onChange(color);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CustomAddCarte(
        icon: Icons.brush,
        main: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Couleur :",
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                  color: currentColor, borderRadius: BorderRadius.circular(5)),
              width: 100,
              height: 35,
            ),
          ],
        ),
        context: context,
      ),
      onTap: () => _colorPicker(),
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

  Color getSelectedColor() {
    return currentColor;
  }
}
