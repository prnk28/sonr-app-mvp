import 'package:flutter/material.dart';
import 'data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'service/device/desktop.dart';

// This file is the default main entry-point for go-flutter application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices(isDesktop: true);
  runApp(DesktopApp());
}

class DesktopApp extends StatelessWidget {
  const DesktopApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sonr Desktop',
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      home: DesktopHome(
        title: 'Home',
      ),
    );
  }
}

class DesktopHome extends StatelessWidget {
  DesktopHome({Key key, this.title}) : super(key: key);
  final String title;
  final RxInt counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _register();
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
        floatingActionButton: FloatingActionButton(
          onPressed: _increment,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  _increment() {
    counter(counter.value + 1);
    counter.refresh();
  }

  _register() {
    Get.find<DesktopService>().registerEventHandler("counterEvent", () {
      counter(counter.value + 1);
      counter.refresh();
    });
  }
}
