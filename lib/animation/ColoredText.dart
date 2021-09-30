import 'package:flutter/material.dart';

class ColoredText extends StatefulWidget {
  final key = new GlobalKey<_ColoredTextState>();
  final Color from;
  final Color to;
  final String text;

  ColoredText({
    required this.text,
    required this.from,
    required this.to,
  });

  _ColoredTextState createState() => _ColoredTextState();
}

class _ColoredTextState extends State<ColoredText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  Color color = Color(Colors.black.value);

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation =
        ColorTween(begin: widget.from, end: widget.to).animate(controller);

    animation.addListener(() {
      setState(() {
        color = animation.value;
      });
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(color: color),
    );
  }
}
