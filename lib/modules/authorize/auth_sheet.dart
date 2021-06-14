import 'package:sonr_app/service/client/session.dart';
import 'package:sonr_app/style.dart';
import 'contact_auth.dart';
import 'file_auth.dart';
import 'url_auth.dart';

class Authorize {
  /// Invite Received
  static void invite(InviteRequest invite) {
    // Place Controller
    if (invite.payload == Payload.CONTACT) {
      AppRoute.popup(ContactAuthView(false, invite: invite), dismissible: false);
    } else {
      AppRoute.sheet(_InviteRequestSheet(invite: invite), key: ValueKey(invite), dismissible: true, onDismissed: (direction) {
        SonrService.respond(invite.newDeclineResponse());
        AppRoute.closeSheet();
      });
    }
  }

  /// Reply Contact Received
  static void reply(InviteResponse reply) {
    // Open Sheet
    AppRoute.popup(
      Container(
        child: ContactAuthView(true, reply: reply),
      ),
      dismissible: false,
    );
  }
}

/// @ TransferView: Builds Invite View based on InviteRequest Payload Type
class _InviteRequestSheet extends StatelessWidget {
  final InviteRequest invite;

  const _InviteRequestSheet({Key? key, required this.invite}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInUpBig(
      duration: 500.milliseconds,
      child: Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: SonrTheme.boxDecoration,
          height: 460,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 24),
          child: Column(
            children: [
              _InviteRequestFileHeader(
                file: invite.file,
                payload: invite.payload,
                profile: invite.from.profile,
              ),
              _buildView(),
              Divider(
                color: SonrTheme.separatorColor,
              ),
              ColorButton.primary(
                onPressed: () {
                  SessionService.decisionForInvite(true);
                  AppRoute.closeSheet();
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
      return _InviteRequestFileContent(file: invite.file);
    } else if (invite.payload == Payload.URL) {
      return URLAuthView(invite);
    } else {
      return FileAuthView(invite);
    }
  }
}

/// @ Header: Auth Invite File Header
class _InviteRequestFileHeader extends StatelessWidget {
  final Payload payload;
  final Profile profile;
  final SonrFile file;

  const _InviteRequestFileHeader({Key? key, required this.payload, required this.profile, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return // @ Header
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      [
        Container(
            margin: EdgeInsets.only(top: 8, left: 8),
            decoration: SonrTheme.boxCircleDecoration,
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
        sNameText(profile: profile),
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

  /// Returns Widget Text of SName
  Widget sNameText({required Profile profile}) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: profile.sName,
            style: TextStyle(
                fontFamily: "RFlex", fontWeight: FontWeight.w300, fontSize: 20, color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black)),
        TextSpan(
            text: ".snr/",
            style: TextStyle(
                fontFamily: "RFlex",
                fontWeight: FontWeight.w100,
                fontSize: 20,
                color: UserService.isDarkMode ? SonrColor.White.withOpacity(0.8) : SonrColor.Black.withOpacity(0.8))),
      ]),
    );
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
class _InviteRequestFileContent extends StatelessWidget {
  final SonrFile file;

  const _InviteRequestFileContent({Key? key, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.275),
      width: Get.width,
      decoration: BoxDecoration(color: SonrTheme.backgroundColor, borderRadius: BorderRadius.circular(22)),
      padding: EdgeInsets.all(8),
      child: _buildView(Width.ratio(0.8), Height.ratio(0.3)),
    );
  }

  Widget _buildView(double width, double height) {
    if (file.payload.isMedia) {
      return file.single.thumbBuffer.length > 0
          ? Image.memory(
              Uint8List.fromList(file.single.thumbBuffer),
              fit: BoxFit.fitWidth,
            )
          : file.single.mime.type.gradient();
    } else {
      return RiveContainer(type: RiveBoard.Documents, width: width, height: height);
    }
  }
}
