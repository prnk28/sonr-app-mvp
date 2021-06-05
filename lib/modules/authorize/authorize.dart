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
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.transparent,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 42.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: Neumorphic.floating(theme: Get.theme),
                width: _getWidth(context),
                height: _getHeight(context),
                margin: _getMargin(context),
                child: _buildView(),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: Neumorphic.floating(theme: Get.theme, shape: BoxShape.circle),
                  padding: EdgeInsets.all(4),
                  child: Container(
                    width: 80,
                    height: 80,
                    child: invite.from.profile.hasPicture()
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(Uint8List.fromList(invite.from.profile.picture)),
                          )
                        : SonrIcons.Avatar.greyWith(size: 80),
                  )),
            )
          ],
        ));
  }

  EdgeInsets _getMargin(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return EdgeInsets.symmetric(horizontal: 8);
  }

  double _getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.65 - 110;
  }

  double _getWidth(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var factor = width * 0.15;
    return width - factor;
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
