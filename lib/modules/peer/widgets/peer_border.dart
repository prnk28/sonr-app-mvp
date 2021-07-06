import 'package:lottie/lottie.dart';
import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_app/style/style.dart';

/// @ Peer Avatar with Rive Board Border
class PeerAvatarBorder extends StatelessWidget {
  final PeerController controller;

  const PeerAvatarBorder({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.invite(),
      child: SizedBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 34),
                  child: _PeerLottieBorder(
                    controller: controller,
                  )),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Obx(
                  () => AnimatedOpacity(
                      opacity: controller.opacity.value,
                      duration: 150.milliseconds,
                      child: ProfileAvatar.fromPeer(
                        controller.peer.value,
                        size: 80,
                      )),
                )),
          ],
        ),
      ),
    );
  }
}

class _PeerLottieBorder extends StatelessWidget {
  final PeerController controller;

  const _PeerLottieBorder({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 96,
        width: 96,
        child: controller.obx(
          (session) {
            return Obx(() {
              if (session!.progress.value > 0) {
                return Lottie.asset(LottieFile.Sending.path);
              } else {
                return Lottie.asset(LottieFile.Complete.path);
              }
            });
          },
          onEmpty: Container(),
          onError: (_) => Lottie.asset(LottieFile.Decline.path),
          onLoading: Lottie.asset(LottieFile.Pending.path),
        ));
  }
}
