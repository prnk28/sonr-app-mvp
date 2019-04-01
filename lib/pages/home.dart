import 'package:flutter/material.dart';
import 'package:sonar_frontend/utils/profile_util.dart';
import 'package:sonar_frontend/widgets/profile_info.dart';
import 'package:sonar_frontend/widgets/sonar_stack.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 4BBEE3 Zima Blue
    return Scaffold(
        appBar: AppBar(
          title: Text("Sonar"),
          backgroundColor: Colors.indigo[800],
          elevation: 0,
          leading: Icon(Icons.menu),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              tooltip: 'Air it',
              onPressed: null,
            ),
          ],
        ),
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.indigo[800],
                Colors.indigo[700],
                Colors.indigo[600],
                Colors.indigo[400],
              ],
            ),
          ),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ProfileInfo(profileStorage: ProfileStorage()),
              SonarStack()
            ],
          )),
        ));
  }
}
