export 'data/data.dart';
export 'widgets/widgets.dart';
import 'package:sonr_app/style/style.dart';

import 'data/data.dart';

class IntelHeader extends GetView<IntelController> implements PreferredSizeWidget {
  IntelHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          controller.obx(
            (state) {
              return "Welcome".heading(
                color: Get.theme.focusColor,
                align: TextAlign.start,
              );
            },
            onEmpty: "Welcome".heading(
              color: Get.theme.focusColor,
              align: TextAlign.start,
            ),
            onLoading: "Welcome".heading(
              color: Get.theme.focusColor,
              align: TextAlign.start,
            ),
            onError: (_) => "Welcome".heading(
              color: Get.theme.focusColor,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}
