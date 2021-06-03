import 'package:sonr_app/modules/auth/auth_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'contact_auth.dart';
import 'file_auth.dart';
import 'media_auth.dart';
import 'url_auth.dart';

class Auth {
  /// Invite Received
  static void invite(AuthInvite invite) {
    // Place Controller
    final controller = Get.put<AuthController>(AuthController());

    // Open Sheet
    Get.bottomSheet(
      _AuthInviteSheet(controller: controller, invite: invite),
      isDismissible: false,
    );
  }

  /// Reply Contact Received
  static void reply(AuthReply reply) {
    // Place Controller
    final controller = Get.put<AuthController>(AuthController());

    // Open Sheet
    Get.bottomSheet(
      _AuthReplySheet(controller: controller, reply: reply),
      isDismissible: false,
    );
  }
}

//// @ TransferView: Builds Invite View based on AuthInvite Payload Type
class InviteOverlayView extends StatelessWidget {
  final AuthInvite invite;

  const InviteOverlayView({required this.invite, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BounceInDown(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        color: Colors.transparent,
        child: _buildView(),
      ),
    );
  }

  // Builds View By Payload
  Widget _buildView() {
    if (invite.payload == Payload.FILE) {
      return FileAuthView(invite);
    } else if (invite.payload == Payload.MEDIA) {
      return MediaAuthView(invite);
    } else if (invite.payload == Payload.CONTACT) {
      return ContactAuthView(false, invite: invite);
    } else if (invite.payload == Payload.URL) {
      return URLAuthView(invite);
    } else {
      return FileAuthView(invite);
    }
  }
}

//// @ TransferView: Builds Invite View based on AuthInvite Payload Type - Contact Only
class ReplyOverlayView extends StatelessWidget {
  final AuthReply? reply;

  const ReplyOverlayView({this.reply, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: ContactAuthView(true, reply: reply),
    );
  }
}

//// @ TransferView: Builds Invite View based on AuthInvite Payload Type
class _AuthInviteSheet extends StatelessWidget {
  final AuthController controller;
  final AuthInvite invite;

  const _AuthInviteSheet({Key? key, required this.controller, required this.invite}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BounceInDown(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        color: Colors.transparent,
        child: _buildView(),
      ),
    );
  }

  // Builds View By Payload
  Widget _buildView() {
    if (invite.payload == Payload.FILE) {
      return FileAuthView(invite);
    } else if (invite.payload == Payload.MEDIA) {
      return MediaAuthView(invite);
    } else if (invite.payload == Payload.CONTACT) {
      return ContactAuthView(false, invite: invite);
    } else if (invite.payload == Payload.URL) {
      return URLAuthView(invite);
    } else {
      return FileAuthView(invite);
    }
  }
}

//// @ TransferView: Builds Invite View based on AuthInvite Payload Type - Contact Only
class _AuthReplySheet extends StatelessWidget {
  final AuthController controller;
  final AuthReply reply;
  const _AuthReplySheet({Key? key, required this.controller, required this.reply}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: ContactAuthView(true, reply: reply),
    );
  }
}
