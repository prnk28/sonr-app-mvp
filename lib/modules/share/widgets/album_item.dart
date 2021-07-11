import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';

class AlbumItem extends StatelessWidget {
  final bool isSelected;
  final AssetPathEntity entity;
  const AlbumItem({Key? key, required this.isSelected, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        decoration: isSelected ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: AppColor.Blue.withOpacity(0.9)) : BoxDecoration(),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        duration: 150.milliseconds,
        child: _buildLabel());
  }

  Widget _buildLabel() {
    return isSelected
        ? entity.name.subheading(color: AppColor.White, fontSize: 20)
        : entity.name.subheading(color: Get.theme.hintColor, fontSize: 20);
  }
}

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
            Obx(() => ShowcaseItem.fromType(
                  type: ShowcaseType.AlbumDropdown,
                  child: ArrowButton.infoList(
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
                  ),
                )),
          ],
        ));
  }
}
