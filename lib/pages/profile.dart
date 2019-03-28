import 'package:flutter/material.dart';
import 'package:sonar_frontend/widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 4BBEE3 Zima Blue
    return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
              },
            ),
              ],
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProfileCard()
              ],
            ));
  }
}
