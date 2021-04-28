import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';

class ExplorerDesktopView extends StatelessWidget {
  ExplorerDesktopView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to Sonr',
          ),
        ],
      ),
    );
  }
}
