import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'media_controller.dart';
import 'share_controller.dart';
import 'package:sonr_app/style/style.dart';

class SharePopupView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        appBar: DesignAppBar(
          centerTitle: true,
          title: "Share".headFour(
            color: Get.theme.focusColor,
            weight: FontWeight.w800,
            align: TextAlign.start,
          ),
          leading: ActionButton(icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart), onPressed: () => Get.back(closeOverlays: true)),
        ),
        body: CustomScrollView(
          slivers: [
            // @ Builds Profile Header
            SliverPadding(padding: EdgeInsets.all(14)),
            SliverToBoxAdapter(child: _TagsView()),
            // @ Builds List of Social Tile
            _MediaView()
          ],
        ));
  }
}

class _MediaView extends GetView<MediaController> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _MediaItem(
              item: controller.currentAlbum.value.entityAtIndex(index),
            );
          },
          childCount: controller.currentAlbum.value.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12.0, crossAxisSpacing: 6.0));
  }
}

class _MediaItem extends StatelessWidget {
  final AssetEntity item;

  const _MediaItem({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<Uint8List>>((thumbnail) {
      _setThumbnail(thumbnail);
      if (thumbnail.value.length > 0) {
        return Image.memory(thumbnail.value);
      } else {
        return CircularProgressIndicator();
      }
    }, Uint8List(0).obs);
  }

  Future<void> _setThumbnail(Rx<Uint8List> thumb) async {
    var data = await item.thumbDataWithSize(320, 320);
    thumb(data);
  }
}

/// @ Card Tags View for Album Names
class _TagsView extends GetView<MediaController> {
  const _TagsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                controller.gallery.length,
                (index) => GestureDetector(
                    onTap: () {
                      controller.setAlbum(controller.gallery[index]);
                    },
                    child: controller.gallery[index].tag(isSelected: controller.isCurrent(index))),
              )),
        ),
      ),
    );
  }
}
