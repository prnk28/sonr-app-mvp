import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'button_view.dart';
import 'share_controller.dart';
import 'package:sonr_app/style.dart';

class SharePopupView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
        appBar: DetailAppBar(
          title: "Share",
          onPressed: () => controller.close(),
          action: AnimatedScale(
              scale: controller.hasSelected.value ? 1.0 : 0.0,
              child: ActionButton(
                onPressed: () => controller.confirmMediaSelection(),
                iconData: SonrIcons.Share,
                banner: ActionBanner.selected(controller.selectedItems.length),
              )),
        ),
        body: Stack(children: [
          CustomScrollView(
            slivers: [
              // @ Builds Profile Header
              SliverToBoxAdapter(child: ShareOptionsRow()),
              SliverPadding(padding: EdgeInsets.only(top: 8)),
              SliverToBoxAdapter(
                  child: Container(padding: EdgeInsets.only(left: 24), child: "Media".section(align: TextAlign.start, color: Get.theme.focusColor))),
              SliverToBoxAdapter(child: _TagsView()),
              SliverPadding(padding: EdgeInsets.all(4)),
              // @ Builds List of Social Tile
              _MediaView()
            ],
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 8) {
                Get.find<ShareController>().shiftPrevAlbum();
              } else if (details.delta.dx < -8) {
                Get.find<ShareController>().shiftNextAlbum();
              }
            },
          )
        ])));
  }
}

class _MediaView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _MediaItem(
              item: controller.currentAlbum.value.entityAtIndex(index),
            );
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
  bool isSelected = false;
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
        return GestureDetector(
          onTap: _toggleImage,
          onLongPress: _openMedia,
          child: Container(
            alignment: Alignment.center,
            child: Stack(children: [
              // Thumbnail
              Container(
                  foregroundDecoration: isSelected ? BoxDecoration(color: Colors.black54) : null,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: MemoryImage(thumbnail!),
                    fit: BoxFit.fitWidth,
                  ))),

              // Video Icon
              widget.item.type == AssetType.video
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            color: UserService.isDarkMode ? SonrColor.White.withOpacity(0.75) : SonrColor.Black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.all(4),
                        child: SonrIcons.Video.gradient(size: 28, value: SonrGradients.NorseBeauty),
                      ),
                    )
                  : Container(),

              // Select Icon
              isSelected ? Center(child: SonrIcons.Check.whiteWith(size: 42)) : Container(),
            ]),
          ),
        );
      } else {
        return widget.item.icon();
      }
    } else {
      return HourglassIndicator();
    }
  }

  Future<void> _openMedia() async {
    var file = await widget.item.file;
    if (file != null) {
      OpenFile.open(file.path);
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

  void _toggleImage() {
    isSelected = !isSelected;
    if (isSelected) {
      Get.find<ShareController>().chooseMediaItem(widget.item, thumbnail!);
    } else {
      Get.find<ShareController>().removeMediaItem(widget.item, thumbnail!);
    }
    setState(() {});
  }
}

/// @ Card Tags View for Album Names
class _TagsView extends GetView<ShareController> {
  const _TagsView({Key? key}) : super(key: key);
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
                            child: controller.gallery[index].tag(isSelected: controller.isCurrent(index))),
                      ))),
        ),
      ),
    );
  }
}
