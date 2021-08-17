import 'package:budjet_app/pages/views/PageCompte.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

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
      debugShowCheckedModeBanner: false,
      title: 'Budjet',
      theme: ThemeData(
          primaryColor: myBlue,
          fontFamily: 'Roboto',
          primarySwatch: myBlue,
          scaffoldBackgroundColor: const Color(0xffF7F7FD)),
      home: PageCompte(),
    );
  }
}
