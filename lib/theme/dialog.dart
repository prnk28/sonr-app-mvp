import 'package:get/get.dart';
import 'package:sonr_app/modules/card/card_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class SonrDialog {
  // Properties
  final bool barrierDismissible;
  final bool useRootNavigator;
  final bool useSafeArea;
  final EdgeInsets margin;
  final Widget view;

  // ^ Default Constructer ^ //
  SonrDialog(this.view, this.margin, this.barrierDismissible, this.useRootNavigator, this.useSafeArea) {
    var childView = _SonrDialogView(view, margin);
    Get.dialog(
      childView,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      barrierColor: SonrColor.dialogBackground,
      transitionCurve: Curves.bounceInOut,
    );
  }

  // ^ Invited for Transfer Margin by Payload ^ //
  factory SonrDialog.invite(AuthInvite invite) {
    // Find Margin for Payload
    EdgeInsets margin;
    if (invite.payload == Payload.MEDIA) {
      margin = EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 90);
    } else if (invite.payload == Payload.CONTACT) {
      margin = EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 180);
    } else {
      margin = EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 450);
    }

    // Check Payload
    if (invite.payload == Payload.MEDIA) {
      return SonrDialog(MediaCard.invite(invite: invite), margin, false, true, true);
    } else if (invite.payload == Payload.CONTACT) {
      return SonrDialog(ContactCard.invite(invite: invite), margin, false, true, true);
    } else if (invite.payload == Payload.URL) {
      return SonrDialog(URLCard.invite(invite: invite), margin, false, true, true);
    } else {
      return SonrDialog(FileCard.invite(invite: invite), margin, false, true, true);
    }
  }

  // ^ Reply with contact ^ //
  factory SonrDialog.reply(AuthReply reply) {
    EdgeInsets margin = EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 180);
    return SonrDialog(ContactCard.reply(reply: reply), margin, false, true, true);
  }

  // ^ Large Sized General Dialog 3/4 Screen ^ //
  factory SonrDialog.large(Widget widget, {bool barrierDismissible = false, bool useRootNavigator = true, bool useSafeArea = true}) {
    EdgeInsets margin = EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 150);
    return SonrDialog(widget, margin, barrierDismissible, useRootNavigator, useSafeArea);
  }

  // ^ Medium Sized General Dialog - 1/2 Screen ^ //
  factory SonrDialog.medium(Widget widget, {bool barrierDismissible = true, bool useRootNavigator = false, bool useSafeArea = true}) {
    EdgeInsets margin = EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 250);
    return SonrDialog(widget, margin, barrierDismissible, useRootNavigator, useSafeArea);
  }

  // ^ Small Sized General Dialog - 1/4 Screen ^ //
  factory SonrDialog.small(Widget widget, {bool barrierDismissible = true, bool useRootNavigator = false, bool useSafeArea = true}) {
    EdgeInsets margin = EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 400);
    return SonrDialog(widget, margin, barrierDismissible, useRootNavigator, useSafeArea);
  }
}

class _SonrDialogView extends StatelessWidget {
  final Widget view;
  final EdgeInsets margin;

  const _SonrDialogView(this.view, this.margin, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        margin: margin,
        borderRadius: BorderRadius.circular(30),
        backendColor: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(color: SonrColor.base),
          child: view,
        ));
  }
}
