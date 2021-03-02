import 'package:flutter/foundation.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:media_gallery/media_gallery.dart';
import 'dart:io';

// ^ MediaPicker Sheet View ^ //
class MediaPickerSheet extends StatefulWidget {
  final Function(MediaFile file) onMediaSelected;
  MediaPickerSheet({@required this.onMediaSelected});
  @override
  _MediaPickerSheetState createState() => _MediaPickerSheetState();
}

class _MediaPickerSheetState extends State<MediaPickerSheet> {
  ValueNotifier<MediaGalleryItem> _selectedItem = ValueNotifier<MediaGalleryItem>(null);
  ValueNotifier<List<Media>> _mediaList = ValueNotifier<List<Media>>(MediaService.totalMedia);

  @override
  Widget build(BuildContext context) {
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
                        setMediaCollection(index);
                      }),

                      // Top Right Confirm Button
                      SonrButton.circle(onPressed: () => confirm(), icon: SonrIcon.accept),
                    ])),

            // @ Create Grid View
            ValueListenableBuilder(
                builder: (BuildContext context, List<Media> list, Widget child) {
                  return Container(
                    width: Get.width - 10,
                    height: 368,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ValueListenableBuilder(
                              builder: (BuildContext context, MediaGalleryItem selected, Widget child) {
                                return _SonrMediaButton(
                                  MediaGalleryItem(index, list[index]),
                                  checkSelected(index, selected),
                                  (item) => select(item),
                                );
                              },
                              valueListenable: _selectedItem);
                        }),
                  );
                },
                valueListenable: _mediaList),
          ])),
    );
  }

  checkSelected(int index, MediaGalleryItem selected) {
    if (selected != null) {
      return selected.index == index;
    }
    return false;
  }

  setMediaCollection(int index) async {
    var updatedCollection = MediaService.gallery[index];
    var data = await MediaService.getMediaFromCollection(updatedCollection);
    _mediaList.value = data;
  }

  select(MediaGalleryItem item) async {
    _selectedItem.value = item;
  }

  confirm() async {
    if (_selectedItem.value != null) {
      widget.onMediaSelected(await _selectedItem.value.getMediaFile());
    } else {
      SonrSnack.invalid("No Media Selected");
    }
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
