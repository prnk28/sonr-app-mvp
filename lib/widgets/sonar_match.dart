import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sonar_frontend/main.dart';
import 'package:sonar_frontend/widgets/authorization_dialog.dart';

class SonarMatch extends StatefulWidget {
  final Widget child;
  SonarMatch({Key key, this.child}) : super(key: key);
  _SonarMatchState createState() => _SonarMatchState();
}

class _SonarMatchState extends State<SonarMatch> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<DocumentCallback, DocumentCallback>(
        converter: (store) => store.state,
        builder: (context, document) {
          if (document.documentId == "null") {
            return Container(width: 0, height: 0);
          } else {
            return Container(
                child: AuthDialog(document: document));
          }
        });
  }
}
