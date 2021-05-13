import 'package:sonr_app/style/style.dart';
import 'contact_auth.dart';
import 'file_auth.dart';
import 'media_auth.dart';
import 'url_auth.dart';

//// @ TransferCardView: Builds Invite View based on AuthInvite Payload Type
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

//// @ TransferCardView: Builds Invite View based on AuthInvite Payload Type - Contact Only
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
