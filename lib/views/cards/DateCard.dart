import 'package:budjet_app/convert/DateHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'CustomCard.dart';

class DateCard extends StatefulWidget {
  final DateTime init;
  final Function changeInitialDate;
  final Function changeEndDate;
  final bool afficherEnd;
  DateCard(
      {required this.afficherEnd,
      required this.changeInitialDate,
      required this.changeEndDate,
      required this.init});
  @override
  State<DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {
  late DateTime initial, end;

  @override
  void initState() {
    print('widget init : ${widget.init}');
    super.initState();
    initial = widget.init;
    end = widget.init;
    initializeDateFormatting();
  }

  @override
  void didUpdateWidget(covariant DateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('update widget ?');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: CustomAddCarte(
            icon: Icons.calendar_today,
            main: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date :",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
                Text(
                  DateHelper.joursMoisAnnee.format(initial),
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
              ],
            ),
            context: context,
          ),
          onTap: () => pickDateInitial(context),
        ),
        widget.afficherEnd
            ? InkWell(
                child: CustomAddCarte(
                  icon: Icons.calendar_today,
                  main: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date de fin :",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                      ),
                      Text(
                        DateHelper.joursMoisAnnee.format(end),
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                      ),
                    ],
                  ),
                  context: context,
                ),
                onTap: () => pickDateEnd(context),
              )
            : Container(),
      ],
    );
  }

  Future pickDateInitial(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Locale('fr'),
    );
    if (date == null) return;
    widget.changeInitialDate(date);
    setState(() {
      initial = date;
      if (end.isBefore(initial) || initial.day != end.day) {
        widget.changeEndDate(date);
        end = initial;
      }
    });
  }

  Future pickDateEnd(BuildContext context) async {
    bool lastDay = false;
    DateTime lastDayMonthOfInitial = (initial.month < 12)
        ? new DateTime(initial.year, initial.month + 1, 0)
        : new DateTime(initial.year + 1, 1, 0);
    //si l'utilisateur selectionne le dernier jour du mois
    if (initial.day == lastDayMonthOfInitial.day) {
      lastDay = true;
    }
    final date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: initial,
        lastDate: DateTime(2100),
        selectableDayPredicate: (DateTime val) {
          if (val.month == DateTime.february && initial.day > 28) {
            return val.day == 28;
          } else if (lastDay) {
            DateTime lastDayMonthOfInitial = (val.month < 12)
                ? new DateTime(val.year, val.month + 1, 0)
                : new DateTime(val.year + 1, 1, 0);
            return val.day == lastDayMonthOfInitial.day;
          } else
            return val.day == initial.day;
        });
    if (date == null) return;
    widget.changeEndDate(date);
    setState(() {
      end = date;
    });
  }
}
