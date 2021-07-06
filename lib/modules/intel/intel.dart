export 'data/data.dart';
import 'package:sonr_app/style/style.dart';

import 'data/data.dart';
import 'widgets/badge_count.dart';
import 'widgets/nearby_row.dart';

class IntelHeader extends GetView<IntelController> {
  IntelHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Obx(
          () => AnimatedSlider.slideDown(
              child: _buildView(
            NodeService.status.value,
          )),
        ));
  }

  Widget _buildView(Status status) {
    if (status.isConnected) {
      return _IntelHeaderStatusActive(
        key: ValueKey<Status>(Status.CONNECTED),
      );
    } else if (status == Status.FAILED) {
      return _IntelHeaderStatusFailed(
        key: ValueKey<Status>(Status.FAILED),
      );
    } else {
      return _IntelHeaderStatusInitial(
        key: ValueKey<Status>(Status.IDLE),
      );
    }
  }
}

class _IntelHeaderStatusInitial extends GetView<IntelController> {
  const _IntelHeaderStatusInitial({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        "Connecting..".heading(
          color: Get.theme.focusColor,
          align: TextAlign.start,
        ),
        Opacity(
          opacity: 0.7,
          child: HourglassIndicator(),
        ),
      ],
    );
  }
}

class _IntelHeaderStatusActive extends GetView<IntelController> {
  const _IntelHeaderStatusActive({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => controller.title.value.heading(
              color: Get.theme.focusColor,
              align: TextAlign.start,
            )),
        Obx(() => AnimatedSlider.fade(child: _buildChildView(controller.badgeVisible.value)))
      ],
    );
  }

  Widget _buildChildView(bool isBadgeVisible) {
    if (isBadgeVisible) {
      return IntelBadgeCount(key: ValueKey(true));
    } else {
      return NearbyPeersRow(key: ValueKey(false));
    }
  }
}

class _IntelHeaderStatusFailed extends GetView<IntelController> {
  const _IntelHeaderStatusFailed({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Logger.openIntercom(),
      child: "Failed".heading(
        color: SonrColor.Critical,
        align: TextAlign.center,
      ),
    );
  }
}
