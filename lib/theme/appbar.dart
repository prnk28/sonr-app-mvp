import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/theme/theme.dart';

enum AppBarType {
  Title,
  Leading,
  Action,
  LeadingAction,
}

class SonrAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SonrText title;
  final Widget leading;
  final Widget action;
  final AppBarType type;

  @override
  final Size preferredSize;
  static const toolbarHeight = kToolbarHeight + 16 * 2;

  SonrAppBar(
    this.type, {
    this.title,
    this.leading,
    this.action,
    Key key,
  })  : preferredSize = Size.fromHeight(toolbarHeight),
        super(key: key);

  factory SonrAppBar.title(String title) {
    return SonrAppBar(AppBarType.Title, title: SonrText.appBar(title));
  }

  factory SonrAppBar.leading(String title, SonrButton leading) {
    return SonrAppBar(
      AppBarType.Leading,
      title: SonrText.appBar(title),
      leading: leading,
    );
  }

  factory SonrAppBar.action(String title, SonrButton action) {
    return SonrAppBar(AppBarType.Action, title: SonrText.appBar(title), action: action);
  }

  factory SonrAppBar.leadingWithAction(String title, SonrButton leading, SonrButton action) {
    return SonrAppBar(AppBarType.LeadingAction, title: SonrText.appBar(title), leading: leading, action: action);
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppBarType.Title:
        assert(title != null);
        return NeumorphicAppBar(title: title);
        break;
      case AppBarType.Leading:
        assert(title != null && leading != null);
        return NeumorphicAppBar(title: title, leading: leading);
        break;
      case AppBarType.Action:
        assert(title != null && action != null);
        return NeumorphicAppBar(title: title, actions: [action]);
        break;
      case AppBarType.LeadingAction:
        assert(title != null && action != null && leading != null);
        return NeumorphicAppBar(title: title, leading: leading, actions: [action]);
        break;
    }
    return Container();
  }
}

class SonrDialogBar extends StatelessWidget {
  // Properties
  final SonrText title;
  final Function onCancel;
  final Function onAccept;

  // Constructer
  const SonrDialogBar({Key key, @required this.title, @required this.onCancel, @required this.onAccept}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 16 * 2,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // @ Top Left Close/Cancel Button
            SonrButton.close(onCancel),

            // @ Title
            Expanded(child: Center(child: title)),

            // @ Top Right Confirm Button
            SonrButton.accept(onAccept)
          ]),
    );
  }
}
