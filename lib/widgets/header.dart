import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/theme/theme.dart';

enum _SonrDialogHeaderType { Title, Leading, Action, TwoButton, CloseAccept, Sliver }

class SonrHeaderBar extends StatelessWidget {
  // Properties
  final Widget title;
  final _SonrDialogHeaderType type;
  final Widget leading;
  final Widget action;
  final Widget flexibleSpace;
  final double height;

  // Sliver Attributes
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool primary;
  final bool automaticallyImplyLeading;
  final double expandedHeight;

  // Constructer
  const SonrHeaderBar(
      {Key key,
      @required this.title,
      @required this.type,
      this.leading,
      this.action,
      this.flexibleSpace,
      this.pinned,
      this.floating,
      this.snap,
      this.primary,
      this.automaticallyImplyLeading,
      this.expandedHeight,
      this.height = kToolbarHeight + 16 * 2})
      : super(key: key);

  factory SonrHeaderBar.title({@required Widget title}) {
    return SonrHeaderBar(
      title: title,
      type: _SonrDialogHeaderType.Title,
    );
  }

  factory SonrHeaderBar.leading({Widget title, @required Widget leading, double height}) {
    return SonrHeaderBar(
      title: title ?? Container(),
      type: _SonrDialogHeaderType.Leading,
      leading: leading,
      height: height,
    );
  }

  factory SonrHeaderBar.action({@required Widget title, @required Widget action}) {
    return SonrHeaderBar(
      title: title,
      type: _SonrDialogHeaderType.Action,
      action: action,
    );
  }

  factory SonrHeaderBar.twoButton({@required Widget title, @required Widget leading, @required Widget action}) {
    return SonrHeaderBar(
      title: title,
      type: _SonrDialogHeaderType.TwoButton,
      leading: leading,
      action: action,
    );
  }

  factory SonrHeaderBar.closeAccept({Widget title, @required Function onCancel, @required Function onAccept}) {
    return SonrHeaderBar(
        title: title,
        type: _SonrDialogHeaderType.CloseAccept,
        leading: SonrButton.circle(onPressed: onCancel, icon: SonrIcon.close),
        action: SonrButton.circle(onPressed: onAccept, icon: SonrIcon.accept));
  }

  factory SonrHeaderBar.sliver(
      {@required Widget leading,
      @required Widget action,
      @required Widget flexibleSpace,
      pinned: true,
      floating: true,
      snap: true,
      primary: true,
      automaticallyImplyLeading: false,
      expandedHeight: 285.0}) {
    return SonrHeaderBar(
        title: null,
        type: _SonrDialogHeaderType.Sliver,
        leading: leading,
        action: action,
        flexibleSpace: flexibleSpace,
        pinned: pinned,
        floating: floating,
        snap: snap,
        primary: primary,
        automaticallyImplyLeading: automaticallyImplyLeading,
        expandedHeight: expandedHeight);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize
    var items = <Widget>[];

    // Check HeaderBar Type
    switch (type) {
      case _SonrDialogHeaderType.Title:
        items = [Expanded(child: Center(child: title))];
        break;
      case _SonrDialogHeaderType.Leading:
        items = [leading, Spacer(), Center(child: title), Spacer()];
        break;
      case _SonrDialogHeaderType.Action:
        items = [Spacer(), Expanded(child: Center(child: title)), Spacer(), action];
        break;
      case _SonrDialogHeaderType.TwoButton:
        items = [leading, Expanded(child: Center(child: title)), action];
        break;
      case _SonrDialogHeaderType.CloseAccept:
        items = [leading, Expanded(child: Center(child: title)), action];
        break;
      case _SonrDialogHeaderType.Sliver:
        return SliverAppBar(
          pinned: pinned,
          floating: floating,
          snap: snap,
          primary: primary,
          automaticallyImplyLeading: automaticallyImplyLeading,
          flexibleSpace: flexibleSpace,
          toolbarHeight: kToolbarHeight + 32 * 2,
          expandedHeight: expandedHeight,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[leading, Spacer(), action],
          ),
        );
        break;
    }

    return Container(
      height: height,
      padding: EdgeInsets.only(top: 0, bottom: 15, left: 14, right: 14),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items),
    );
  }
}
