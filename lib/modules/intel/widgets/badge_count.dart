import 'package:sonr_app/modules/intel/intel.dart';
import 'package:sonr_app/style/style.dart';

class IntelBadgeCount extends GetView<IntelController> {
  const IntelBadgeCount({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8),
        child: controller.obx(
          (state) {
            if (state != null) {
              return Obx(() => FadeOut(
                    animate: !controller.badgeVisible.value,
                    duration: 400.milliseconds,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        state.text(),
                        state.icon(),
                      ],
                    ),
                  ));
            } else {
              return Container();
            }
          },
          onEmpty: Container(),
          onLoading: Container(),
          onError: (_) => Container(),
        ));
  }
}
