import 'package:sonr_app/style/style.dart';

class ShareHoverView extends GetView<ShareController> {
  final Member member;

  ShareHoverView({required this.member});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppTheme.BackgroundColor,
            border: Border.all(
              color: AppTheme.ForegroundColor,
              width: 1.5,
            )),
        constraints: BoxConstraints(maxWidth: 200, maxHeight: 314),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        duration: 1500.milliseconds,
        child: controller.obx((state) {
          if (state != null) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              _ShareHoverPeerInfo(peer: member.active),
              Divider(),
              Padding(padding: EdgeInsets.only(top: 8)),
              _ShareHoverSession(
                session: state,
              ),
            ]);
          }
          return Container();
        },
            onEmpty: Column(
              children: [
                _ShareHoverPeerInfo(peer: member.active),
                Divider(),
                Padding(padding: EdgeInsets.only(top: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ShareHoverCameraButtonItem(peer: member),
                    Padding(padding: EdgeInsets.only(left: 24)),
                    _ShareHoverMediaButtonItem(peer: member),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ShareHoverFileButtonItem(peer: member),
                    Padding(padding: EdgeInsets.only(left: 24)),
                    _ShareHoverContactButtonItem(peer: member),
                  ],
                ),
              ],
            )));
  }
}

class _ShareHoverSession extends StatelessWidget {
  final Session session;

  const _ShareHoverSession({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (session.status.value == SessionStatus.Accepted) {
        return Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColor.Blue,
            ),
            "Sending".section(color: AppTheme.GreyColor, fontSize: 14),
          ],
        ));
      } else if (session.status.value == SessionStatus.Denied) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SimpleIcons.Close.gradient(),
              "Denied".section(color: AppTheme.GreyColor, fontSize: 14),
            ],
          ),
        );
      } else if (session.status.value == SessionStatus.Pending) {
        return Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleLoader(scale: 1),
            "Pending".section(color: AppTheme.GreyColor, fontSize: 14),
          ],
        ));
      }
      Future.delayed(1500.milliseconds, () {
        AppRoute.close();
      });
      return SimpleIcons.Check.gradient(value: DesignGradients.ItmeoBranding);
    });
  }
}

class _ShareHoverPeerInfo extends StatelessWidget {
  final Peer peer;

  const _ShareHoverPeerInfo({Key? key, required this.peer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        peer.platform.icon(color: AppTheme.GreyColor, size: 24),
        Padding(padding: EdgeInsets.only(left: 8)),
        _buildName().subheading(fontSize: 28, color: AppTheme.ItemColor),
      ],
    );
  }

  String _buildName() {
    String name = peer.profile.fullName;
    if (peer.profile.isLongFullName) {
      name = "${peer.profile.firstName} ${peer.profile.lastInitialDot}";
    }
    return name;
  }
}

/// #### Camera Share Button
class _ShareHoverCameraButtonItem extends GetView<ShareController> {
  final Member peer;
  const _ShareHoverCameraButtonItem({required this.peer});
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ComplexButton(
          label: 'Camera',
          size: K_HOVER_BUTTON_SIZE,
          onPressed: () => controller.chooseThenInvite(peer: peer, option: ChooseOption.Camera),
          type: ComplexIcons.Camera,
          fontSize: 18,
        ));
  }
}

/// #### Camera Share Button
class _ShareHoverMediaButtonItem extends GetView<ShareController> {
  final Member peer;
  const _ShareHoverMediaButtonItem({required this.peer});
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ComplexButton(
          label: 'Media',
          size: K_HOVER_BUTTON_SIZE,
          onPressed: () => controller.chooseThenInvite(peer: peer, option: ChooseOption.Media),
          type: ComplexIcons.MediaSelect,
          fontSize: 18,
        ));
  }
}

/// #### File Share Button
class _ShareHoverFileButtonItem extends GetView<ShareController> {
  final Member peer;
  const _ShareHoverFileButtonItem({required this.peer});
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ComplexButton(
          label: 'File',
          size: K_HOVER_BUTTON_SIZE,
          onPressed: () => controller.chooseThenInvite(peer: peer, option: ChooseOption.File),
          type: ComplexIcons.Document,
          fontSize: 18,
        ));
  }
}

/// #### Contact Share Button
class _ShareHoverContactButtonItem extends GetView<ShareController> {
  final Member peer;
  const _ShareHoverContactButtonItem({required this.peer});
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ComplexButton(
          label: 'Contact',
          type: ComplexIcons.ContactCard,
          onPressed: () => controller.chooseThenInvite(peer: peer, option: ChooseOption.Contact),
          size: K_HOVER_BUTTON_SIZE,
          fontSize: 18,
        ));
  }
}
