import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/pages/profile.dart';
import 'package:sonar_frontend/utils/color_builder.dart';
import 'package:sonar_frontend/widgets/profile_info.dart';
import 'package:sonar_frontend/sonar/sonar_button.dart';
import 'package:sonar_frontend/widgets/sonar_match.dart';
import 'package:sonar_frontend/widgets/sonar_stack.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  ProfileInfo(),
                  SonarStack()
                ],
              ),
              SonarMatch()
            ],
          )),
        ),
        drawer: ProfilePage(),
        appBar: AppBar(
          title: Text("Sonar"),
          backgroundColor: getInitialColor(),
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              tooltip: 'Air it',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              tooltip: 'Air it',
              onPressed: () {
                PermissionHandler()
                    .requestPermissions([PermissionGroup.locationWhenInUse]);
              },
            ),
          ],
        ),
        floatingActionButton: SonarButton());
  }
}
