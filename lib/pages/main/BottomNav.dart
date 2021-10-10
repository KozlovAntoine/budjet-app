import 'package:budjet_app/ad_manager.dart';
import 'package:budjet_app/convert/DateHelper.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function changeDate;
  final DateTime initialDate;
  BottomNav({required this.changeDate, required this.initialDate});
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late DateTime current;

  @override
  void initState() {
    super.initState();
    current = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              tooltip: 'Mois précédent',
              icon: const Icon(
                Icons.arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                AdManager.incr();
                setState(() {
                  if (current.month > 1)
                    current = new DateTime(current.year, current.month - 1, 1);
                  else
                    current = new DateTime(current.year - 1, 12, 1);
                });
                widget.changeDate(current);
              },
            ),
            Text(
              DateHelper.moisAnnee.format(current).capitalize(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            IconButton(
              tooltip: 'Mois suivant',
              icon: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  AdManager.incr();
                  if (current.month < 12)
                    current = new DateTime(current.year, current.month + 1, 1);
                  else
                    current = new DateTime(current.year + 1, 1, 1);
                });
                widget.changeDate(current);
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
