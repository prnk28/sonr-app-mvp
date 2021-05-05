import 'package:flutter/material.dart';
import 'package:sonr_app/style/style.dart';

class LinkDesktopView extends StatelessWidget {
  LinkDesktopView({Key key}) : super(key: key);
  final RxInt counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          SonrService.locationInfo().toString(),
        ),
      ],
    ));
  }
}
