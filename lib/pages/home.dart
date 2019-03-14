import 'package:flutter/material.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sonar",
        home: Scaffold(
          appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SonarCard(),
          ],
        )
      )
    );
  }
}
