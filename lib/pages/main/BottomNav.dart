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
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  if (current.month > 1)
                    current = new DateTime(current.year, current.month - 1, 1);
                  else
                    current = new DateTime(current.year - 1, 12, 1);
                });
                widget.changeDate(current);
              },
            ),
            Text(DateHelper.moisAnnee.format(current)),
            IconButton(
              tooltip: 'Mois suivant',
              icon: const Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
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
