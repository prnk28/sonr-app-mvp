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
    return Obx(() => SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Obx(() => _MediaItem(
                  item: controller.currentAlbum.value.entityAtIndex(index),
                ));
          },
          childCount: controller.currentAlbum.value.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 4.0, crossAxisSpacing: 4.0)));
  }
}

class _MediaItem extends StatefulWidget {
  final AssetEntity item;

  const _MediaItem({Key? key, required this.item}) : super(key: key);

  @override
  _MediaItemState createState() => _MediaItemState();
}

class _MediaItemState extends State<_MediaItem> {
  bool hasLoaded = false;
  Uint8List? thumbnail;
  @override
  void initState() {
    _setThumbnail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (hasLoaded) {
      if (thumbnail != null) {
        return Image.memory(thumbnail!);
      } else {
        return widget.item.icon();
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<void> _setThumbnail() async {
    var data = await widget.item.thumbData;
    if (data != null) {
      thumbnail = data;
    }
    hasLoaded = true;
    setState(() {});
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
