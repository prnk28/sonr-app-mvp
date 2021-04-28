import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/service/device/desktop.dart';

class TransferDesktopView extends StatelessWidget {
  TransferDesktopView({Key key, this.title}) : super(key: key);
  final String title;
  final RxInt counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: SonrColor.Secondary,
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      );
    });
  }
}
