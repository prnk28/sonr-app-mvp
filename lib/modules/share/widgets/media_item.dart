import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/style.dart';

class MediaItem extends StatefulWidget {
  final AssetEntity item;

  const MediaItem({Key? key, required this.item}) : super(key: key);

  @override
  _MediaItemState createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  bool hasLoaded = false;
  bool isSelected = false;
  Uint8List? thumbnail;

  @override
  void initState() {
    _setThumbnail();
    super.initState();
  }

  @override
  void didUpdateWidget(MediaItem oldWidget) {
    if (oldWidget.item != widget.item) {
      hasLoaded = false;
      _setThumbnail();
    }
    super.didUpdateWidget(oldWidget);
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
                            color: Preferences.isDarkMode ? SonrColor.White.withOpacity(0.75) : SonrColor.Black.withOpacity(0.75),
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
