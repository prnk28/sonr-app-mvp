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
      Popup.open(ContactAuthView(false, invite: invite), dismissible: false);
    } else {
      Sheet.dissmissible(ValueKey(invite), _AuthInviteSheet(controller: controller, invite: invite), (direction) {
        SonrService.respond(invite.newDeclineReply());
        Sheet.close();
      });
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
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: SonrColor.White, borderRadius: BorderRadius.circular(24)),
          width: Width.ratio(0.95),
          height: Height.ratio(0.7),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              _AuthInviteFileHeader(
                file: invite.file,
                payload: invite.payload,
                profile: invite.from.profile,
              ),
              _buildView(),
            ],
          )),
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

class _AuthInviteFileHeader extends StatelessWidget {
  final Payload payload;
  final Profile profile;
  final SonrFile file;

  const _AuthInviteFileHeader({Key? key, required this.payload, required this.profile, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return // @ Header
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(color: SonrColor.White, shape: BoxShape.circle, boxShadow: [
            BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: SonrColor.Black.withOpacity(0.4)),
          ]),
          padding: EdgeInsets.all(4),
          child: Container(
            width: 80,
            height: 80,
            child: profile.hasPicture()
                ? CircleAvatar(
                    backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                  )
                : SonrIcons.Avatar.greyWith(size: 80),
          )),

      // From Information
      Container(
        width: Width.ratio(0.6),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: profile.firstName,
            style: _buildTextStyle(FontWeight.bold),
          ),
          TextSpan(
            text: "wants to share an ",
            style: _buildTextStyle(FontWeight.normal),
          ),
          TextSpan(
            text: file.prettyType(),
            style: _buildTextStyle(FontWeight.bold),
          ),
          TextSpan(
            text: " of size ",
            style: _buildTextStyle(FontWeight.normal),
          ),
          TextSpan(
            text: file.prettySize(),
            style: _buildTextStyle(FontWeight.bold),
          ),
        ])),
      )
    ]);
  }

  /// @ Helper: Builds Text Style for Spans
  TextStyle _buildTextStyle(FontWeight weight) {
    if (weight == FontWeight.bold) {
      return TextStyle(
        fontFamily: "Manrope",
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black,
      );
    } else {
      return TextStyle(
        fontFamily: "OpenSans",
        fontWeight: FontWeight.w400,
        fontSize: 19,
        color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black,
      );
    }
  }
}
