import 'package:sonr_app/modules/authorize/auth_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'contact_auth.dart';
import 'file_auth.dart';
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

/// @ TransferView: Builds Invite View based on AuthInvite Payload Type
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
              Divider(),
              ColorButton.primary(
                onPressed: () {
                  CardService.handleInviteResponse(true, invite);
                  Sheet.close();
                },
                text: "Accept",
                icon: SonrIcons.Check,
                margin: EdgeInsets.symmetric(horizontal: 54),
              ),
            ],
          )),
    );
  }

  // Builds View By Payload
  Widget _buildView() {
    if (invite.payload.isTransfer) {
      return _AuthInviteFileContent(file: invite.file);
    } else if (invite.payload == Payload.URL) {
      return URLAuthView(invite);
    } else {
      return FileAuthView(invite);
    }
  }
}

/// @ Header: Auth Invite File Header
class _AuthInviteFileHeader extends StatelessWidget {
  final Payload payload;
  final Profile profile;
  final SonrFile file;

  const _AuthInviteFileHeader({Key? key, required this.payload, required this.profile, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return // @ Header
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      [
        Container(
            margin: EdgeInsets.only(top: 8, left: 8),
            decoration: BoxDecoration(color: SonrColor.White, shape: BoxShape.circle, boxShadow: [
              BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: SonrColor.Black.withOpacity(0.4)),
            ]),
            padding: EdgeInsets.all(4),
            child: Container(
              width: 64,
              height: 64,
              child: profile.hasPicture()
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                    )
                  : SonrIcons.User.gradient(size: 42),
            )),
        profile.sNameText(isDarkMode: UserService.isDarkMode),
      ].column(),

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
            text: " wants to share an ",
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
        fontFamily: "RFlex",
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black,
      );
    } else {
      return TextStyle(
        fontFamily: "RFlex",
        fontWeight: FontWeight.w300,
        fontSize: 19,
        color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black,
      );
    }
  }
}

/// @ Content: Auth Invite File Content
class _AuthInviteFileContent extends StatelessWidget {
  final SonrFile file;

  const _AuthInviteFileContent({Key? key, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.275),
      decoration: Neumorphic.floating(
        theme: Get.theme,
      ),
      padding: EdgeInsets.all(8),
      child: _buildView(Width.ratio(0.8), Height.ratio(0.3)),
    );
  }

  Widget _buildView(double width, double height) {
    if (file.payload.isMedia) {
      return file.single.thumbBuffer.length > 0
          ? Image.memory(
              Uint8List.fromList(file.single.thumbBuffer),
              fit: BoxFit.fitHeight,
            )
          : file.single.mime.type.gradient();
    } else {
      return RiveContainer(type: RiveBoard.Documents, width: width, height: height);
    }
  }
}
