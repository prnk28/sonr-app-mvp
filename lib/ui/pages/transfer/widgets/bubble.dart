import 'package:sonar_app/ui/pages/transfer/widgets/pending_bubble.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';

class Bubble extends StatelessWidget {
  final double value;
  final Peer peer;
  Bubble(this.value, this.peer, {Key key}) : super(key: key);

  final SonrController sonr = Get.find();
  @override
  Widget build(BuildContext context) {
    // ^ Looking for Peer ^ //
    return Obx(() {
      if (sonr.status() == SonrStatus.Searching) {
        // @ Check if Ive already Declined
        if (sonr.auth() != null) {
          // Check if im the peer
          if (_isCurrentPeer()) {
            return Positioned(
                top: calculateOffset(value).dy,
                left: calculateOffset(value).dx,
                child: Container(
                    child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 10,
                      lightSource: LightSource.topLeft,
                      color: Colors.grey[300]),
                  child: Container(
                    width: 80,
                    height: 80,
                    child: FlareActor("assets/animations/denied.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "animate"),
                  ),
                )));
          }
        }
      }
      // ^ Check if im the Peer ^ //
      else if (sonr.status() == SonrStatus.Pending) {
        if (_isCurrentPeer()) {
          return PendingBubble(value, peer);
        }
      }

      // ^ Check if User is Transferring ^ //
      else if (sonr.status() == SonrStatus.Transferring) {
        if (_isCurrentPeer()) {
          return Positioned(
              top: calculateOffset(value).dy,
              left: calculateOffset(value).dx,
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Neumorphic(
                    style: NeumorphicStyle(
                        depth: 10, boxShape: NeumorphicBoxShape.circle()),
                    child: SizedBox(
                      child: CircularProgressIndicator(strokeWidth: 6),
                      height: 86.0,
                      width: 86.0,
                    )),
                buildBubbleContent(peer),
              ]));
        }
      }

      // ^ Active Peer you can invite me ^
      return Positioned(
          top: calculateOffset(value).dy,
          left: calculateOffset(value).dx,
          child: GestureDetector(
              onTap: () async {
                // Send Offer to Bubble
                sonr.invitePeer(peer);
              },
              child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 10,
                      lightSource: LightSource.topLeft,
                      color: Colors.grey[300]),
                  child: Container(
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Spacer(),
                        initialsFromPeer(peer),
                        iconFromPeer(peer),
                      ],
                    ),
                  ))));
    });
  }

  // ** Peer Checking Method ** //
  _isCurrentPeer() {
    if (peer.id == sonr.currentPeer().id) {
      return true;
    } else {
      return false;
    }
  }
}
