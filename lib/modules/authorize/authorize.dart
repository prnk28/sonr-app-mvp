import 'package:sonr_app/modules/authorize/auth_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'contact_auth.dart';
import 'file_auth.dart';
import 'media_auth.dart';
import 'url_auth.dart';

class Authorize {
  /// Invite Received
  static void invite(AuthInvite invite) {
    // Place Controller
    final controller = Get.put<AuthorizeController>(AuthorizeController());
    if (invite.payload == Payload.CONTACT) {
      Get.dialog(ContactAuthView(false, invite: invite), barrierDismissible: false);
    } else {
      Get.bottomSheet(_AuthInviteSheet(controller: controller, invite: invite), isDismissible: false);
    }
  }

  /// Reply Contact Received
  static void reply(AuthReply reply) {
    // Place Controller
    //final controller = Get.put<AuthorizeController>(AuthorizeController());

    // Open Sheet
    Get.bottomSheet(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        color: Colors.transparent,
        child: ContactAuthView(true, reply: reply),
      ),
      isDismissible: false,
    );
  }
}

//// @ TransferView: Builds Invite View based on AuthInvite Payload Type
class _AuthInviteSheet extends StatelessWidget {
  final AuthorizeController controller;
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
    } else if (invite.payload == Payload.URL) {
      return URLAuthView(invite);
    } else {
      return FileAuthView(invite);
    }
  }
}
