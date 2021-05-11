import 'package:flutter/material.dart';
import 'data/data.dart';
import 'package:sonr_app/style/style.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices(isDesktop: true);
  runApp(App(isDesktop: true));
}
