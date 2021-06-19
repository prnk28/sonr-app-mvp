// Exports
export 'views/contact_auth.dart';
export 'views/file_auth.dart';
export 'views/url_auth.dart';

// Imports
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';
import 'views/contact_auth.dart';
import 'views/file_auth.dart';
import 'views/url_auth.dart';

class Authorize {
  /// Invite Received
  static void invite(InviteRequest invite) {
    // Place Controller
    if (invite.payload == Payload.CONTACT) {
      AppRoute.popup(ContactAuthView(false, invite: invite), dismissible: false);
    } else {
      AppRoute.sheet(_InviteRequestSheet(invite: invite), key: ValueKey(invite), dismissible: true, onDismissed: (direction) {
        NodeService.respond(invite.newDeclineResponse());
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
      child: BoxContainer(
          padding: EdgeInsets.only(left: 8, right: 8),
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
                color: SonrTheme.dividerColor,
              ),
              ColorButton.primary(
                onPressed: () {
                  ReceiverService.decide(true);
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
        CircleContainer(
            margin: EdgeInsets.only(top: 8, left: 8),
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
        [profile.sName.lightSpan(), ".snr/".paragraphSpan()].rich(),
      ].column(),

      // From Information
      Container(
          width: Width.ratio(0.6),
          child: [
            profile.firstName.headingSpan(fontSize: 20),
            " wants to share an ".lightSpan(fontSize: 19),
            file.prettyType().headingSpan(fontSize: 20),
            " of size ".lightSpan(fontSize: 19),
            file.prettySize().headingSpan(fontSize: 20)
          ].rich())
    ]);
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
