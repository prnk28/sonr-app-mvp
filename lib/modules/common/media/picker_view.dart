import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/share/share.dart';

class MediaPicker {
  final bool isSheet;

  // @ Media Picker as Sheet
  static Future<MediaItem> sheet() async {
    if (await Permission.photos.request().isGranted) {
      Completer<MediaItem> completer;
      // Display Bottom Sheet
      Get.bottomSheet(MediaPickerSheet(onMediaSelected: (MediaItem file) {
        completer.complete(file);
      }), isDismissible: true);

      // Return Future
      return completer.future;
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
      return null;
    }
  }

  // @ Media Picker as Dialog
  static Widget picker({Key key}) {
    return MediaPickerView(key: key);
  }

  MediaPicker(this.isSheet);
}

// ^ Root Media Queue Container ^ //
class MediaPickerView extends GetView<MediaQueueController> {
  MediaPickerView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: SonrStyle.normal,
      child: OpacityAnimatedWidget(
        enabled: true,
        delay: 600.milliseconds,
        duration: 600.milliseconds,
        child: Obx(() => _buildChildFromStatus(controller.status.value)),
      ),
    );
  }

  // @ Method to check View Status
  Widget _buildChildFromStatus(MediaQueueViewStatus status) {
    if (status == MediaQueueViewStatus.NeedsPermissions) {
      return _MediaPermissionsView();
    } else {
      return _MediaQueueGrid(key: ValueKey<MediaQueueViewStatus>(MediaQueueViewStatus.Ready));
    }
  }
}

// ^ Permissions View ^ //
class _MediaPermissionsView extends GetView<MediaQueueController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SonrText.subtitle("Need Gallery Permissions"),
        ColorButton.primary(onPressed: controller.requestPermission, text: "Proceed"),
      ],
    );
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
          child: SizedBox(
            height: 140,
            child: Column(
              children: [
                Row(
                  children: [PlainButton(onPressed: Get.find<ShareController>().shrink, icon: SonrIcon.close)],
                ),
                AlbumsDropdown(
                  index: controller.albumIndex,
                  hasSelected: controller.hasSelected,
                  onConfirmed: controller.confirm,
                ),
              ],
            ),
          ),
        ),

        // @ Window Content
        SliverFillRemaining(
          hasScrollBody: false,
          child: Obx(() {
            if (controller.currentAlbum.length > 0) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: Get.height * 0.6,
                child: AnimatedSlideSwitcher.slideDown(
                  duration: 1200.milliseconds,
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
            } else {
              return Center(child: SonrText.subtitle("Album is Empty."));
            }
          }),
        ),
      ]),
    );
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
enum MediaQueueViewStatus { NeedsPermissions, Loading, Ready }

extension MediaQueueViewStatusUtils on MediaQueueViewStatus {
  static MediaQueueViewStatus statusFromPermissions(bool val) {
    return val ? MediaQueueViewStatus.Ready : MediaQueueViewStatus.NeedsPermissions;
  }
}

class MediaQueueController extends GetxController {
  // Album Properties
  final albumIndex = (-1).obs;
  final currentAlbum = RxList<MediaItem>(MediaService.allAlbum.value.assets);

  // Item Properties
  final hasSelected = false.obs;
  final selectedItem = Rx<MediaItem>(null);
  final selectedIndex = (-1).obs;

  // View Properties
  final status = Rx<MediaQueueViewStatus>(MediaQueueViewStatusUtils.statusFromPermissions(UserService.permissions.value.hasGallery));

  onInit() async {
    // Check Permissions
    if (UserService.permissions.value.hasGallery) {
      // Check Albums
      if (MediaService.hasGallery.value) {
        currentAlbum(MediaService.allAlbum.value.assets);
        currentAlbum.refresh();
        status(MediaQueueViewStatus.Ready);
      } else {
        await MediaService.refreshGallery();
        currentAlbum(MediaService.allAlbum.value.assets);
        currentAlbum.refresh();
        status(MediaQueueViewStatus.Ready);
      }
    } else {
      status(MediaQueueViewStatus.NeedsPermissions);
    }

    // Add Listener
    albumIndex.listen(_handleAlbumIndex);
    super.onInit();
  }

  // @ Request Media Permissions
  requestPermission() async {
    // Initialize
    bool granted = false;

    // Check Device
    if (DeviceService.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        granted = true;
      } else {
        granted = false;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        granted = true;
      } else {
        granted = false;
      }
    }

    // Display error if not granted
    if (!granted) {
      SonrSnack.error("Sonr cannot open Media Picker without Gallery Permissions");
      Get.find<ShareController>().shrink(delay: 750.milliseconds);
    }
    // Refresh Gallery
    else {
      await MediaService.refreshGallery();
      currentAlbum(MediaService.allAlbum.value.assets);
      currentAlbum.refresh();
    }

    // Update User Settings and Status
    UserService.permissions.value.update();
    status(MediaQueueViewStatusUtils.statusFromPermissions(granted));
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
