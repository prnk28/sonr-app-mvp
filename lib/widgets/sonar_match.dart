import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sonar_frontend/widgets/authorization_dialog.dart';

class SonarMatch extends StatefulWidget {
  final Widget child;
  SonarMatch({Key key, this.child}) : super(key: key);
  _SonarMatchState createState() => _SonarMatchState();
}

class _SonarMatchState extends State<SonarMatch> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<String, String>(
        converter: (store) => store.state.toString(),
        builder: (context, document) {
          if (document == "null") {
            return Container(width: 0, height: 0);
          } else {
            return Container(
                child: AuthDialog(document: document));
          }
        });
  }
}
