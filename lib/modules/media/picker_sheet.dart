import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:media_gallery/media_gallery.dart';
import 'dart:io';

// ^ MediaPicker Sheet View ^ //
class PickerSheet extends StatelessWidget {
  final Function(MediaFile file) onMediaSelected;
  PickerSheet({@required this.onMediaSelected});

  @override
  Widget build(BuildContext context) {
    return GetX<MediaPickerController>(
        init: MediaPickerController(onMediaSelected),
        builder: (controller) {
          return NeumorphicBackground(
            borderRadius: BorderRadius.circular(40),
            backendColor: Colors.transparent,
            child: Neumorphic(
                style: NeumorphicStyle(color: SonrColor.base),
                child: Column(children: [
                  // @ Header Buttons
                  Container(
                      height: kToolbarHeight + 16 * 2,
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //  Top Left Close/Cancel Button
                            SonrButton.circle(onPressed: () => Get.back(), icon: SonrIcon.close),

                            // Drop Down
                            SonrDropdown.albums(MediaService.gallery, width: Get.width - 200, onChanged: (index) {
                              controller.setMediaCollection(MediaService.gallery[index]);
                            }),

                            // Top Right Confirm Button
                            SonrButton.circle(onPressed: () => controller.confirm(), icon: SonrIcon.accept),
                          ])),

                  controller.loaded.value
                      ? Obx(() => Container(
                            width: Get.width - 10,
                            height: 368,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                                itemCount: controller.album.length,
                                itemBuilder: (context, index) {
                                  return Obx(() => _SonrMediaButton(
                                        MediaGalleryItem(index, controller.album[index]),
                                        controller.selectedItem.value.index == index,
                                        (item) => controller.selectedItem(item),
                                      ));
                                }),
                          ))
                      : NeumorphicProgressIndeterminate(),
                ])),
          );
        });
  }
}

// ^ Widget that Creates Button from Media and Index ^ //
class _SonrMediaButton extends StatefulWidget {
  // Files
  final MediaGalleryItem item;
  final Function(MediaGalleryItem) onTap;
  final bool isSelected;

  _SonrMediaButton(this.item, this.isSelected, this.onTap, {Key key}) : super(key: key);

  @override
  _SonrMediaButtonState createState() => _SonrMediaButtonState();
}

class _SonrMediaButtonState extends State<_SonrMediaButton> {
  File file;
  Uint8List thumbnail;
  bool loaded = false;

  @override
  void initState() {
    getThumbnail();
    super.initState();
  }

  void getThumbnail() async {
    var data = await widget.item.getThumbnail();
    setState(() {
      thumbnail = data;
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => widget.item.openFile(),
      child: NeumorphicButton(
          padding: EdgeInsets.zero,
          onPressed: () => widget.onTap(widget.item),
          style: widget.isSelected ? SonrStyle.mediaButtonPressed : SonrStyle.mediaButtonDefault,
          child: Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
            loaded
                ? Hero(
                    tag: widget.item.media.id,
                    child: DecoratedBox(
                        child: Image.memory(Uint8List.fromList(thumbnail), fit: BoxFit.cover),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8))),
                  )
                : Payload.MEDIA.icon(IconType.Neumorphic),
            widget.item.getIcon(),
            widget.isSelected
                ? Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 4, bottom: 4),
                    child: SonrIcon.gradient(SonrIcon.success.data, FlutterGradientNames.hiddenJaguar, size: 40))
                : Container()
          ])),
    );
  }
}

// ^ Media Picker Controller ^ //
class MediaPickerController extends GetxController {
  // Properties
  final album = <Media>[].obs;
  final collection = Rx<MediaCollection>();
  final selectedItem = Rx<MediaGalleryItem>();
  final loaded = false.obs;
  final Function(MediaFile) onMediaSelected;
  MediaPickerController(this.onMediaSelected);

  //  Initial Method
  void onInit() {
    MediaService.refreshGallery().then((value) {
      album(MediaService.totalMedia);
      loaded(true);
    });
    super.onInit();
  }

  // Method Updates the Current Media Collection
  setMediaCollection(MediaCollection updatedCollection) async {
    loaded(false);
    // Reset Loaded
    collection(updatedCollection);

    // Get Media
    var result = await MediaService.getMediaFromCollection(updatedCollection);

    // Set All Media
    album.assignAll(result);
    loaded(true);
  }

  // Confirm Selected File
  confirm() async {
    if (selectedItem.value != null) {
      onMediaSelected(await selectedItem.value.getMediaFile());
      Get.back();
    } else {
      SonrSnack.invalid("No Media Selected");
    }
  }
}
