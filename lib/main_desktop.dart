import 'package:flutter/material.dart';
import 'modules/tray/tray.dart';

// This file is the default main entry-point for go-flutter application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DesktopApp(tray: await SonrTray.init()));
}

class DesktopApp extends StatelessWidget {
  final SonrTray tray;

  const DesktopApp({Key key, @required this.tray}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonr Desktop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        tray: tray,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.tray}) : super(key: key);
  final String title;
  final SonrTray tray;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // Setup a callback for systray triggered event
    widget.tray.registerEventHandler("counterEvent", () {
      setState(() {
        _counter += 1;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
