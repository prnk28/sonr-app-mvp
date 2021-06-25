import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/style/style.dart';

class AlbumHeader extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 24, bottom: 24),
        width: Width.full,
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Media".section(
              align: TextAlign.start,
              color: Get.theme.focusColor,
            ),
            Obx(() => ArrowButton.infoList(
                  offset: Offset(-100, -10),
                  title: controller.currentAlbum.value.name,
                  options: List<InfolistOption>.generate(controller.gallery.length, (index) {
                    return DefaultAlbumUtils.buildInfolistOption(
                        onPressed: () {
                          controller.setAlbum(index);
                          Get.back();
                        },
                        entity: controller.gallery[index]);
                  }),
                )),
          ],
        ));
  }
}
