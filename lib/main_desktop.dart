import 'package:flutter/material.dart';
import 'data/data.dart';
import 'package:sonr_app/style.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices.init(isDesktop: true);
  runApp(SplashPage(isDesktop: true));
}
