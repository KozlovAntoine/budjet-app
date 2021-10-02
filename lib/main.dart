import 'package:budjet_app/pages/main/PageComptes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/database_bud.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool dbIsLoaded = false;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  initDatabase() async {
    print('Loading database ...');
    DatabaseBud databaseBud = DatabaseBud();
    await databaseBud.initDone;
    print('Database is loaded !');
    setState(() {
      dbIsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const myBlue = const MaterialColor(
      0xff1bb2f2,
      const {
        50: const Color(0xff1bb2f2),
        100: const Color(0xff1bb2f2),
        200: const Color(0xff1bb2f2),
        300: const Color(0xff1bb2f2),
        400: const Color(0xff1bb2f2),
        500: const Color(0xff1bb2f2),
        600: const Color(0xff1bb2f2),
        700: const Color(0xff1bb2f2),
        800: const Color(0xff1bb2f2),
        900: const Color(0xff1bb2f2),
      },
    );
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('fr', ''),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Budjet',
        theme: ThemeData(
            primaryColor: myBlue,
            fontFamily: 'Roboto',
            primarySwatch: myBlue,
            scaffoldBackgroundColor: const Color(0xffF7F7FD)),
        home: dbIsLoaded
            ? PageCompte()
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
