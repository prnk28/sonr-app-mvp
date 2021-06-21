import 'dart:io';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:sonr_app/data/data.dart';
import 'package:video_player/video_player.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

///  Builds Container With Image as Decoration or Defaults to None if Not Image
class MetaBox extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SonrFile_Item metadata;

  /// Child to Display above Decoration
  final Widget? child;
  const MetaBox({Key? key, required this.metadata, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (metadata.mime.isImage) {
      return FutureBuilder<File?>(
          initialData: null,
          future: CardService.loadFileFromItem(metadata),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return GestureDetector(
                onTap: () => AppPage.Detail.to(args: DetailPageArgs.media(metadata, snapshot.data)),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black12, BlendMode.luminosity),
                    fit: BoxFit.fitWidth,
                    image: FileImage(snapshot.data!),
                  )),
                  child: child ?? Container(),
                ),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Image.asset('assets/illustrations/NoFiles.png'),
              );
            }
          });
    } else if (metadata.mime.isVideo) {
      return MetaVideo(metadata: metadata);
    } else {
      return MetaIcon(metadata: metadata);
    }
  }
}

/// Builds Icon View from Metadata
class MetaIcon extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SonrFile_Item metadata;
  final double iconSize;
  final double width;
  final double height;
  const MetaIcon({Key? key, required this.metadata, this.iconSize = 60, this.width = 150, this.height = 150}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      width: width,
      height: height,
      child: CircleContainer(
        child: metadata.mime.type.gradient(size: iconSize),
      ),
    );
  }
}

///  Builds Container With Image as SizedBox
class MetaAlbumBox extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SonrFile file;
  final double width;
  final double height;
  final BoxFit fit;

  const MetaAlbumBox({Key? key, required this.file, this.width = 150, this.height = 150, this.fit = BoxFit.contain}) : super(key: key);
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
                  return MetaImageBox(metadata: item, width: width, height: height, fit: fit);
                } else if (item.mime.isVideo) {
                  return MetaVideo(
                    metadata: item,
                    width: width,
                    height: height,
                    autoPlay: true,
                    looping: false,
                  );
                } else {
                  return MetaIcon(
                    metadata: item,
                    width: width,
                    height: height,
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
                      color: SonrColor.Black.withOpacity(0.75),
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

///  Builds Container With Image as SizedBox
class MetaImageBox extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SonrFile_Item metadata;
  final double width;
  final double height;
  final BoxFit fit;

  const MetaImageBox({Key? key, required this.metadata, this.width = 150, this.height = 150, this.fit = BoxFit.contain}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return metadata.mime.isImage
        ? FutureBuilder<File?>(
            initialData: null,
            future: CardService.loadFileFromItem(metadata),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () => metadata.open(),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Image.file(snapshot.data!, fit: BoxFit.cover),
                  ),
                );
              } else {
                return Container(
                  width: width,
                  height: height,
                  child: HourglassIndicator(),
                );
              }
            })
        : Container();
  }
}

/// Builds Metadata Video Player
class MetaVideo extends StatelessWidget {
  /// Transfer Metadata Protobuf
  final SonrFile_Item metadata;
  final double? width;
  final double? height;
  final bool autoPlay;
  final bool allowScreenSleep;
  final bool looping;
  final MediaOrientation orientation;
  const MetaVideo({
    Key? key,
    required this.metadata,
    this.width,
    this.height,
    this.autoPlay = true,
    this.looping = true,
    this.allowScreenSleep = false,
    this.orientation = MediaOrientation.Portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return metadata.mime.isVideo
        ? FutureBuilder<File?>(
            initialData: null,
            future: CardService.loadFileFromItem(metadata),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () => metadata.open(),
                  child: Container(
                    width: width ?? orientation.defaultWidth,
                    height: height ?? orientation.defaultHeight,
                    child: VideoPlayerView.file(
                      snapshot.data!,
                      autoPlay,
                    ),
                  ),
                );
              } else {
                return Container(
                  width: width ?? orientation.defaultWidth,
                  height: height ?? orientation.defaultHeight,
                  child: HourglassIndicator(),
                );
              }
            })
        : Container(
            width: width ?? orientation.defaultWidth,
            height: height ?? orientation.defaultHeight,
          );
  }
}

class PayloadText extends StatelessWidget {
  final Payload payload;
  final SonrFile? file;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;
  final DisplayTextStyle textStyle;
  final bool withCount;

  const PayloadText({
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
        color: color ?? SonrTheme.itemColor,
        fontSize: fontSize,
        fontStyle: fontStyle,
      ),
    );
  }

  String _buildType() {
    if (file != null && payload.isTransfer) {
      // Return Mime for Single
      if (file!.count == 1 || file!.isAllSingleType) {
        return withCount
            ? file!.single.mime.value.toString().capitalizeFirst! + " (${file!.count})"
            : file!.single.mime.value.toString().capitalizeFirst!;
      } else if (file!.count > 1) {
        return withCount ? payload.toString().capitalizeFirst! + " - ${file!.count}" : payload.toString().capitalizeFirst!;
      }
    }
    return payload.toString().capitalizeFirst!;
  }
}

enum VideoPlayerViewType {
  Asset,
  Network,
  File,
}

class VideoPlayerView extends StatefulWidget {
  final VideoPlayerViewType type;
  final File sourceFile;
  final bool autoplay;
  const VideoPlayerView(this.type, {Key? key, required this.sourceFile, required this.autoplay}) : super(key: key);
  factory VideoPlayerView.file(File source, bool autoplay) => VideoPlayerView(VideoPlayerViewType.Network, sourceFile: source, autoplay: autoplay);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.sourceFile)
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
    return Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container());
  }
}