import 'package:flutter/material.dart';
import 'package:sonr_app/pages/register/register.dart';
import 'package:sonr_app/style.dart';

/// A simple scrollable widget
class NotifyingIntroView extends StatefulWidget {
  final List<Widget> pages;

  const NotifyingIntroView({
    Key? key,
    required this.pages,
  }) : super(key: key);

  @override
  _NotifyingIntroViewState createState() => _NotifyingIntroViewState(pages);
}

class _NotifyingIntroViewState extends State<NotifyingIntroView> {
  List<Widget> _pages;
  _NotifyingIntroViewState(this._pages);

  // I don't remember why I added this :(
  // try removing it
  @override
  void didUpdateWidget(NotifyingIntroView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pages != oldWidget.pages) {
      setState(() {
        _pages = widget.pages;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: _pages,
        controller: Get.find<RegisterController>().introPageController,
      ),
    );
  }
}

class NotifyingSetupView extends StatefulWidget {
  final List<Widget> pages;
  final RegisterTitleBar titleBar;
  final RegisterBottomSheet? bottomSheet;
  const NotifyingSetupView({Key? key, required this.pages, required this.titleBar, this.bottomSheet}) : super(key: key);
  @override
  _NotifyingSetupViewState createState() => _NotifyingSetupViewState(pages);
}

class _NotifyingSetupViewState extends State<NotifyingSetupView> {
  List<Widget> _pages;
  _NotifyingSetupViewState(this._pages);

  // I don't remember why I added this :(
  // try removing it
  @override
  void didUpdateWidget(NotifyingSetupView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pages != oldWidget.pages) {
      setState(() {
        _pages = widget.pages;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: SonrTheme.foregroundColor,
        appBar: widget.titleBar,
        body: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: _pages,
              controller: Get.find<RegisterController>().setupPageController,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.bottomSheet,
            )
          ],
        ));
  }
}

/// A simple scrollable widget
class NotifyingPermissionsView extends StatefulWidget {
  final List<Widget> pages;

  const NotifyingPermissionsView({
    Key? key,
    required this.pages,
  }) : super(key: key);

  @override
  _NotifyingPermissionsViewState createState() => _NotifyingPermissionsViewState(pages);
}

class _NotifyingPermissionsViewState extends State<NotifyingPermissionsView> {
  List<Widget> _pages;
  _NotifyingPermissionsViewState(this._pages);

  // I don't remember why I added this :(
  // try removing it
  @override
  void didUpdateWidget(NotifyingPermissionsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pages != oldWidget.pages) {
      setState(() {
        _pages = widget.pages;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: _pages,
        controller: Get.find<RegisterController>().permissionsPageController,
      ),
    );
  }
}
