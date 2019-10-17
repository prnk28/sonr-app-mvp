import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/sonar/sonar_communication.dart';
import 'package:sonar_frontend/utils/color_builder.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sonar.initialize();
    // 4BBEE3 Zima Blue
    return Scaffold(
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: getRandomGradient(),
          ),
          child: Center(
              child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                ],
              )
            ],
          )),
        ),
        appBar: AppBar(
          title: Text("Sonar"),
          backgroundColor: getInitialColor(),
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                PermissionHandler()
                    .requestPermissions([PermissionGroup.locationWhenInUse]);
              },
            ),
          ],
        ),
      );
  }
}
