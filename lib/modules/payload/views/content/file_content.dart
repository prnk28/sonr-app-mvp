import 'dart:io';
import 'package:sonr_app/modules/peer/peer.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:video_player/video_player.dart';

/// #### Post Content for File
class FileContent extends StatelessWidget {
  final SFile file;
  final double iconSize;
  final double width;
  final double height;
  final BoxFit fit;
  const FileContent({Key? key, required this.file, this.iconSize = 60, this.width = 150, this.height = 150, this.fit = BoxFit.contain})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (file.isMultiple) {
      if (file.isAllMedia) {
        return FileAlbumBox(
          file: file,
          width: Get.width,
          height: 100,
          fit: BoxFit.fitHeight,
          iconSize: iconSize,
        );
      }
    } else {
      final item = file.single;
      // Image
      if (item.mime.isImage) {
        return FileItemImageBox(
          fileItem: file.single,
          width: Get.width,
          fit: fit,
          height: height,
        );
      }

      // Video
      else if (item.mime.isVideo) {
        return FileItemVideoBox(
          fileItem: file.single,
          width: Get.width,
        );
      }
    }

    // # Other File
    return FileItemIconBox(
      iconSize: Height.ratio(0.125),
      fileItem: file.single,
      height: height,
      width: width,
    );
  }
}

///  Builds Container With Image as SizedBox
class FileAlbumBox extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SFile file;
  final double width;
  final double height;
  final BoxFit fit;
  final double iconSize;

  const FileAlbumBox({Key? key, required this.file, required this.width, required this.height, required this.fit, required this.iconSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isVisible = true.obs;
    final currentIndex = 0.0.obs;
    return Obx(
      () => Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (value) {
                isVisible(true);
                currentIndex(value.toDouble());
                Future.delayed(1500.milliseconds, () {
                  isVisible(false);
                });
              },
              itemBuilder: (context, index) {
                final item = file.items[index];
                if (item.mime.isImage) {
                  return FileItemImageBox(fileItem: item, width: width, height: height, fit: fit);
                } else if (item.mime.isVideo) {
                  return FileItemVideoBox(
                    fileItem: item,
                    width: width,
                    height: height,
                    autoplay: true,
                    looping: false,
                  );
                } else {
                  return FileItemIconBox(
                    fileItem: item,
                    width: width,
                    height: height,
                    iconSize: iconSize,
                  );
                }
              },
              itemCount: file.count,
            ),
            IgnorePointer(
              child: AnimatedOpacity(
                duration: 200.milliseconds,
                opacity: isVisible.value ? 1.0 : 0.0,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.Black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: EdgeInsets.all(8),
                    child: DotsIndicator(
                      dotsCount: file.count,
                      position: currentIndex.value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds Icon View from Metadata
class FileItemIconBox extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SFile_Item fileItem;
  final double iconSize;
  final double width;
  final double height;
  const FileItemIconBox({Key? key, required this.fileItem, required this.iconSize, required this.width, required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      width: width,
      height: height,
      child: CircleContainer(
        child: fileItem.mime.type.gradient(size: iconSize),
      ),
    );
  }
}

///  Builds Container With Image as SizedBox
class FileItemImageBox extends StatefulWidget {
  /// Transfer Metadata Protobuf
  final SFile_Item fileItem;
  final double width;
  final double height;
  final BoxFit fit;

  const FileItemImageBox({Key? key, required this.fileItem, required this.width, required this.height, required this.fit}) : super(key: key);

  @override
  _FileItemImageBoxState createState() => _FileItemImageBoxState();
}

class _FileItemImageBoxState extends State<FileItemImageBox> {
  late File sourceFile;
  bool fileLoaded = false;
  bool isFile = true;

  @override
  void initState() {
    super.initState();

    // Check if File Exists
    File(widget.fileItem.path).exists().then((value) {
      isFile = value;
      if (value) {
        widget.fileItem.loadFile().then((value) => {
              setState(() {
                sourceFile = value;
                fileLoaded = true;
              })
            });
      } else {
        setState(() {
          fileLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return fileLoaded
        ? GestureDetector(
            onTap: () => widget.fileItem.open(),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: _buildImageChild(),
            ),
          )
        : Container(
            width: widget.width,
            height: widget.height,
            child: CircleLoader(),
          );
  }

  Widget _buildImageChild() {
    if (isFile) {
      return Image.file(sourceFile, fit: BoxFit.cover);
    } else {
      if (widget.fileItem.thumbnail != null) {
        return Image.memory(
          widget.fileItem.thumbnail!,
          fit: BoxFit.fitHeight,
        );
      } else {
        return SimpleIcons.Unknown.icon(color: AppTheme.ItemColor);
      }
    }
  }
}

/// Builds Metadata Video Player
class FileItemVideoBox extends StatefulWidget {
  /// Transfer Metadata Protobuf
  final SFile_Item fileItem;
  final double? width;
  final double? height;
  final bool autoplay;
  final bool allowScreenSleep;
  final bool looping;
  final MediaOrientation orientation;
  const FileItemVideoBox({
    Key? key,
    required this.fileItem,
    this.width,
    this.height,
    this.autoplay = true,
    this.looping = true,
    this.allowScreenSleep = false,
    this.orientation = MediaOrientation.Portrait,
  }) : super(key: key);

  @override
  _FileItemVideoBoxState createState() => _FileItemVideoBoxState();
}

class _FileItemVideoBoxState extends State<FileItemVideoBox> {
  late VideoPlayerController _controller;
  late File sourceFile;

  @override
  void initState() {
    super.initState();
    sourceFile = widget.fileItem.file;
    _controller = VideoPlayerController.file(sourceFile)
      ..initialize().then((_) {
        setState(() {
          _controller.setVolume(0);
          if (widget.autoplay) {
            _controller.play();
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.fileItem.open(),
      child: Container(
        width: widget.width ?? widget.orientation.defaultWidth,
        height: widget.height ?? widget.orientation.defaultHeight,
        child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(
                    width: widget.width ?? widget.orientation.defaultWidth,
                    height: widget.height ?? widget.orientation.defaultHeight,
                    child: CircleLoader(),
                  )),
      ),
    );
  }
}

class FilePayloadText extends StatelessWidget {
  final Payload payload;
  final SFile? file;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;
  final DisplayTextStyle textStyle;
  final bool withCount;

  const FilePayloadText({
    Key? key,
    required this.payload,
    this.file,
    this.color,
    this.withCount = true,
    this.fontSize = 20,
    this.fontStyle = FontStyle.normal,
    this.textStyle = DisplayTextStyle.Subheading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _buildType(),
      style: textStyle.style(
        color: color ?? AppTheme.ItemColor,
        fontSize: fontSize,
        fontStyle: fontStyle,
      ),
    );
  }

  String _buildType() {
    if (file != null && payload.isTransfer) {
      // Return Mime for Single
      if (file!.count == 1 || file!.isAllSingleType) {
        return file!.single.mime.value.toString().capitalizeFirst!;
      } else if (file!.count > 1) {
        return withCount ? payload.toString().capitalizeFirst! + " - ${file!.count}" : payload.toString().capitalizeFirst!;
      }
    }
    return payload.toString().capitalizeFirst!;
  }
}

/// #### TransferCard as List item View
class FileItemView extends StatelessWidget {
  final TransferCard item;

  const FileItemView({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0, top: 16.0),
      child: BoxContainer(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: 400,
        child: Column(
          children: [
            // Owner Info
            ProfileOwnerRow(profile: item.owner),

            // File Content
            Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                child: FileContent(
                  file: item.file!,
                ),
                height: 237),
            Padding(padding: EdgeInsets.only(top: 8)),
            // Info of Transfer
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilePayloadText(payload: item.payload, file: item.file),
                  DateText(date: item.received),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
