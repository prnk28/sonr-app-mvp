import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
            return Container(width: 100, height: 50, child: StreamBuilder(
              stream: Firestore.instance.collection("active-transactions").document(document).snapshots(),
              builder: (context, snap){
                return new Text(
                  snap.data["status"].toString(),
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),);
          }
        });
  }
}
