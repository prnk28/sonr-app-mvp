import 'package:flutter/material.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 4BBEE3 Zima Blue
    return Scaffold(
            appBar: AppBar(
              title: Text('Contact'),
              actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
              },
            ),
              ],
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SonarCard()
              ],
            ));
  }
}
