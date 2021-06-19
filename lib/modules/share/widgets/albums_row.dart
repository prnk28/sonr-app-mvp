import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/modules/share/widgets/album_item.dart';
import 'package:sonr_app/style.dart';

/// @ Card Tags View for Album Names
class AlbumsRow extends GetView<ShareController> {
  const AlbumsRow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        height: 60,
        child: SingleChildScrollView(
          controller: controller.tagsScrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                  controller.gallery.length,
                  (index) => Obx(
                        () => GestureDetector(
                            onTap: () {
                              controller.setAlbum(index);
                            },
                            child: AlbumItem(
                              entity: controller.gallery[index],
                              isSelected: controller.isCurrent(index),
                            )),
                      ))),
        ),
      ),
    );
  }
}
