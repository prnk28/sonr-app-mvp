import 'package:flutter/material.dart';
import 'package:sonar_frontend/utils/profile_util.dart';
import 'package:sonar_frontend/widgets/profile_card.dart';
import 'package:sonar_frontend/widgets/sonar_stack.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 4BBEE3 Zima Blue
    return Scaffold(
            appBar: AppBar(
              title: Text('Sonar'),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SonarStack(),
                ProfileCard(profileStorage: ProfileStorage())
              ],
            ));
  }
}
