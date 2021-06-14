import 'dart:ui';
import 'package:sonr_app/style.dart';

/// @ Standardized Uniform Scaffold
class SonrScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? floatingAction;
  final PreferredSizeWidget? appBar;
  final bool? resizeToAvoidBottomInset;
  final Gradient? gradient;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  SonrScaffold({
    Key? key,
    this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingAction,
    this.gradient,
    this.floatingActionButtonLocation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonrTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(child: body ?? Container()),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingAction,
      bottomSheet: bottomSheet,
    );
  }
}
