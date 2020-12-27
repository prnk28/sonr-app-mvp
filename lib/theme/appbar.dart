import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';

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
      leading: leading,
    );
  }

  factory SonrAppBar.action(String title, SonrButton action) {
    return SonrAppBar(AppBarType.Action,
        title: SonrText.appBar(title), action: action);
  }

  factory SonrAppBar.leadingWithAction(
      String title, SonrButton leading, SonrButton action) {
    return SonrAppBar(AppBarType.LeadingAction,
        title: SonrText.appBar(title), leading: leading, action: action);
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
        return NeumorphicAppBar(
            title: title, leading: leading, actions: [action]);
        break;
    }
    return Container();
  }
}
