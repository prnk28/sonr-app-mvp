import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sonar_frontend/main.dart';
import 'package:sonar_frontend/widgets/authorization_dialog.dart';

class CardOverlay extends StatefulWidget {
  final Widget child;
  CardOverlay({Key key, this.child}) : super(key: key);
  _CardOverlayState createState() => _CardOverlayState();
}

class _CardOverlayState extends State<CardOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
