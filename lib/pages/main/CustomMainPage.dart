import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomMainPage extends StatelessWidget {
  final List<Widget> children;
  final GlobalKey<ScaffoldState> scaffoldKey;
  String? text;
  CustomMainPage(
      {required this.children, required this.scaffoldKey, this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (event) {
        if (event.delta.dx > 0) scaffoldKey.currentState!.openDrawer();
      },
      child: children.isEmpty
          ? Center(child: Text(text == null ? 'Vide' : text!))
          : ListView(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              children: children,
            ),
    );
  }
}

class CustomMainPageRefresh extends StatelessWidget {
  final refresh;
  final List<Widget> children;
  final GlobalKey<ScaffoldState> scaffoldKey;
  CustomMainPageRefresh(
      {required this.children,
      required this.scaffoldKey,
      required this.refresh});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (event) {
        if (event.delta.dx > 0) scaffoldKey.currentState!.openDrawer();
      },
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          children: children,
        ),
      ),
    );
  }
}
