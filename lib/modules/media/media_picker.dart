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
  final RxInt index = (-1).obs;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() async {
    await MediaService.refreshGallery();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    index.listen((val) {
      setMediaCollection(val);
    });
    return NeumorphicBackground(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      backendColor: Colors.transparent,
      child: SonrScaffold.appBarCustom(
        leading: SonrButton.rectangle(
            radius: 20,
            shape: NeumorphicShape.convex,
            onPressed: () => Get.back(),
            icon: SonrIcon.normal(Icons.close, color: SonrPalete.Red, size: 38)),
        floatingActionButton: SonrButton.circle(onPressed: () => confirm(), icon: SonrIcon.accept),
        middle: SonrDropdown.albums(MediaService.gallery, width: Get.width - 100, index: index, margin: EdgeInsets.only(left: 12, right: 12)),
        body: ValueListenableBuilder(
            builder: (BuildContext context, List<Media> list, Widget child) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: Get.height / 2 + 80,
                child: SonrAnimatedSwitcher.fade(
                  duration: 2800.milliseconds,
                  child: GridView.builder(
                      key: ValueKey<List<Media>>(list),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                      itemCount: list != null ? list.length : 0,
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
                ),
              );
            },
            valueListenable: _mediaList),
      ),
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

  final mediaButtonDefault = NeumorphicStyle(intensity: 0.85, color: SonrColor.White);
  final mediaButtonPressed = NeumorphicStyle(depth: -12, intensity: 1, surfaceIntensity: 0.75, shadowDarkColorEmboss: SonrColor.Black);

  @override
  void initState() {
    widget.item.getThumbnail().then((data) {
      if (!mounted) return;
      setState(() {
        thumbnail = data;
        loaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => widget.item.openFile(),
      child: NeumorphicButton(
          padding: EdgeInsets.zero,
          onPressed: () => widget.onTap(widget.item),
          style: widget.isSelected ? mediaButtonPressed : mediaButtonDefault,
          child: Stack(fit: StackFit.expand, children: [
            loaded && thumbnail != null
                ? Hero(
                    tag: widget.item.media.id,
                    child: DecoratedBox(
                        child: Image.memory(thumbnail, fit: BoxFit.cover), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8))),
                  )
                : Payload.MEDIA.icon(IconType.Neumorphic),
            Align(
                child: widget.item.type == MediaType.video
                    ? SonrIcon.gradient(SonrIconData.video, FlutterGradientNames.glassWater, size: 36)
                    : Container(),
                alignment: Alignment.topRight),
            widget.isSelected
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4, bottom: 4),
                    child: SonrIcon.gradient(SonrIcon.success.data, FlutterGradientNames.hiddenJaguar, size: 40))
                : Container()
          ])),
    );
  }
}
