import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Root Media Queue Container ^ //
class MediaPickView extends GetView<MediaQueueController> {
  MediaPickView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Neumorphic(
          style: SonrStyle.normal,
          child: AnimatedSlideSwitcher.fade(
            child: _buildView(controller.status.value),
            duration: const Duration(milliseconds: 2500),
          ),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(MediaQueueViewStatus status) {
    // Return View
    if (status == MediaQueueViewStatus.Loading) {
      return _MediaQueueLoading(key: ValueKey<MediaQueueViewStatus>(MediaQueueViewStatus.Loading));
    } else if (status == MediaQueueViewStatus.Confirmed) {
      return _MediaQueueConfirmed(key: ValueKey<MediaQueueViewStatus>(MediaQueueViewStatus.Confirmed));
    } else {
      return _MediaQueueGrid(key: ValueKey<MediaQueueViewStatus>(MediaQueueViewStatus.Ready));
    }
  }
}

// ^ Loading View ^ //
class _MediaQueueLoading extends GetView<MediaQueueController> {
  _MediaQueueLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ^ Display for Items in Grid ^ //
class _MediaQueueGrid extends GetView<MediaQueueController> {
  _MediaQueueGrid({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: CustomScrollView(slivers: [
        // @ Top Banner
        SliverToBoxAdapter(
          child: AlbumsDropdown(
            index: controller.albumIndex,
            hasSelected: controller.hasSelected,
            onConfirmed: controller.confirm,
          ),
        ),

        // @ Window Content
        SliverFillRemaining(
          hasScrollBody: false,
          child: Obx(() {
            if (MediaService.allAlbum.value.isEmpty) {
              return Center(child: SonrText.subtitle("Album is Empty."));
            } else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: Get.height / 2 + 80,
                child: AnimatedSlideSwitcher.fade(
                  duration: 2800.milliseconds,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                      itemCount: controller.currentAlbum != null ? controller.currentAlbum.length : 0,
                      itemBuilder: (context, index) {
                        return _MediaQueueItem(
                          controller.currentAlbum[index],
                          index,
                        );
                      }),
                ),
              );
            }
          }),
        ),
      ]),
    );
  }
}

// ^ Animation for Selected Item ^ //
class _MediaQueueConfirmed extends GetView<MediaQueueController> {
  _MediaQueueConfirmed({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ^ Widget that Creates Button from Media and Index ^ //
class _MediaQueueItem extends GetView<MediaQueueController> {
  // Files
  final MediaItem item;
  final int index;
  final thumbnail = Rx<Uint8List>(null);

  // ** Constructer ** //
  _MediaQueueItem(this.item, this.index, {Key key}) : super(key: key);

  // ** Sets Item Thumbnail ** //
  initialize() async {
    thumbnail(await controller.getThumbnail(item));
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    return Obx(() => GestureDetector(
          onLongPress: () => item.openFile(),
          child: NeumorphicButton(
              padding: EdgeInsets.zero,
              onPressed: () => controller.selectItem(item, index),
              style: _buildStyle(controller.selectedIndex.value == index),
              child: Stack(fit: StackFit.expand, children: [
                _buildThumbnailView(thumbnail.value != null),
                Align(
                  child: item.isVideo ? SonrIcon.gradient(SonrIconData.video, FlutterGradientNames.glassWater, size: 36) : Container(),
                  alignment: Alignment.topRight,
                ),
                _buildSelected(controller.selectedIndex.value == index),
              ])),
        ));
  }

  // @ Creates Selected View Icon
  Widget _buildSelected(bool isSelected) {
    return isSelected
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 4, bottom: 4),
            child: SonrIcon.gradient(SonrIcon.success.data, FlutterGradientNames.hiddenJaguar, size: 40))
        : Container();
  }

  // @ Creates Style for Selected
  NeumorphicStyle _buildStyle(bool isSelected) {
    return isSelected
        ? NeumorphicStyle(
            depth: -12,
            intensity: 1,
            surfaceIntensity: 0.75,
            shadowDarkColorEmboss: SonrColor.Black,
          )
        : NeumorphicStyle(intensity: 0.85, color: SonrColor.White);
  }

  // @ Builds Thumbnail Image
  Widget _buildThumbnailView(bool isThumbnailReady) {
    return isThumbnailReady
        ? Hero(
            tag: item.id,
            child: DecoratedBox(
                child: Image.memory(thumbnail.value, fit: BoxFit.cover), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8))),
          )
        : Payload.MEDIA.icon(IconType.Neumorphic);
  }
}

// ^ Media Queue Reactive Controller ^ //
enum MediaQueueViewStatus { Loading, Ready, Confirmed }

class MediaQueueController extends GetxController {
  // Album Properties
  final albumIndex = (-1).obs;
  final currentAlbum = RxList<MediaItem>(MediaService.allAlbum.value.assets);

  // Item Properties
  final hasSelected = false.obs;
  final selectedItem = Rx<MediaItem>(null);
  final selectedIndex = (-1).obs;

  // View Properties
  final status = Rx<MediaQueueViewStatus>(MediaQueueViewStatus.Loading);

  onInit() async {
    // Check Albums
    if (MediaService.hasGallery.value) {
      currentAlbum(MediaService.allAlbum.value.assets);
      status(MediaQueueViewStatus.Ready);
    } else {
      await MediaService.refreshGallery();
      currentAlbum(MediaService.allAlbum.value.assets);
      status(MediaQueueViewStatus.Ready);
    }

    // Add Listener
    albumIndex.listen(_handleAlbumIndex);
    super.onInit();
  }

  // @ Return Item Thumbnail ^ //
  Future<Uint8List> getThumbnail(MediaItem item) async {
    return await item.getThumbnail();
  }

  // @ Select Item ^ //
  void selectItem(MediaItem item, int index) async {
    selectedIndex(index);
    selectedItem(item);
    hasSelected(true);
  }

  // @ Confirm Selection ^ //
  void confirm() async {
    if (selectedItem.value != null) {
      Get.find<ShareController>().setMedia(selectedItem.value);
    } else {
      SonrSnack.invalid("No Media Selected");
    }
  }

  // # Handle Album Index Change
  _handleAlbumIndex(int i) async {
    if (i == -1) {
      currentAlbum(MediaService.allAlbum.value.assets);
    } else {
      var newAlbum = MediaService.albums[i];
      currentAlbum(newAlbum.assets);
    }
  }
}
