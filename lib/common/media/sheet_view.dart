import 'package:flutter/foundation.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'dart:io';

import 'dropdown_widget.dart';

// ^ MediaPicker Sheet View ^ //
class MediaPickerSheet extends StatefulWidget {
  final Function(MediaItem file) onMediaSelected;
  MediaPickerSheet({@required this.onMediaSelected});
  @override
  _MediaPickerSheetState createState() => _MediaPickerSheetState();
}

class _MediaPickerSheetState extends State<MediaPickerSheet> {
  ValueNotifier<MediaItem> _selectedItem = ValueNotifier<MediaItem>(null);
  ValueNotifier<List<MediaItem>> _mediaList = ValueNotifier<List<MediaItem>>(MediaService.allAlbum.value.assets);
  final RxInt index = (-1).obs;

  @override
  void initState() {
    super.initState();
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
        leading: ShapeButton.rectangle(
            radius: 20,
            shape: NeumorphicShape.convex,
            onPressed: () => Get.back(),
            icon: SonrIcon.normal(Icons.close, color: SonrPalette.Red, size: 38)),
        floatingActionButton: ShapeButton.circle(onPressed: () => confirm(), icon: SonrIcon.accept),
        middle: AlbumsDropdown(index: index),
        body: MediaService.allAlbum.value.isEmpty
            ? Center(child: SonrText.subtitle("Album is Empty."))
            : ValueListenableBuilder(
                builder: (BuildContext context, List<MediaItem> list, Widget child) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: Get.height / 2 + 80,
                    child: AnimatedSlideSwitcher.fade(
                      duration: 2800.milliseconds,
                      child: GridView.builder(
                          key: ValueKey<List<MediaItem>>(list),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                          itemCount: list != null ? list.length : 0,
                          itemBuilder: (context, index) {
                            return ValueListenableBuilder(
                                builder: (BuildContext context, MediaItem selected, Widget child) {
                                  return _SonrMediaButton(
                                    list[index],
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

  checkSelected(int index, MediaItem selected) {
    if (selected != null) {
      return selected.index == index;
    }
    return false;
  }

  setMediaCollection(int index) async {
    var updatedCollection = MediaService.albums[index];
    _mediaList.value = updatedCollection.assets;
  }

  select(MediaItem item) async {
    _selectedItem.value = item;
  }

  confirm() async {
    if (_selectedItem.value != null) {
      widget.onMediaSelected(_selectedItem.value);
    } else {
      SonrSnack.invalid("No Media Selected");
    }
  }
}

// ^ Widget that Creates Button from Media and Index ^ //
class _SonrMediaButton extends StatefulWidget {
  // Files
  final MediaItem item;
  final Function(MediaItem) onTap;
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
                    tag: widget.item.id,
                    child: DecoratedBox(
                        child: Image.memory(thumbnail, fit: BoxFit.cover), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8))),
                  )
                : Payload.MEDIA.icon(IconType.Neumorphic),
            Align(
                child: widget.item.isVideo ? SonrIcon.gradient(SonrIconData.video, FlutterGradientNames.glassWater, size: 36) : Container(),
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
