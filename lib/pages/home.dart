import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sonar_frontend/widgets/profile_card.dart';
import 'package:sonar_frontend/widgets/sonar_stack.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sonar",
        home: Scaffold(
            appBar: AppBar(
              title: Text('Sonar'),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SonarStack(),
                Padding(padding: EdgeInsets.all(50.0)),
                ProfileCard()
              ],
            )));
  }
}
