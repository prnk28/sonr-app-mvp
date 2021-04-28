import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'details_view.dart';

///  Builds Container With Image as Decoration or Defaults to None if Not Image
class MetaBox extends StatelessWidget {
  /// TransferCard Metadata Protobuf
  final Metadata metadata;

  /// Child to Display above Decoration
  final Widget child;
  const MetaBox({Key key, @required this.metadata, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return metadata.isImage
        ? FutureBuilder<File>(
            initialData: null,
            future: MediaService.loadFileFromMetadata(metadata),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () => Get.to(MediaDetailsView(metadata, snapshot.data), transition: Transition.fadeIn),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      colorFilter: ColorFilter.mode(Colors.black12, BlendMode.luminosity),
                      fit: BoxFit.fitWidth,
                      image: FileImage(snapshot.data),
                    )),
                    child: child ?? Container(),
                  ),
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            })
        : Container(
            child: child,
          );
  }
}

/// Builds Icon View from Metadata
class MetaIcon extends StatelessWidget {
  /// TransferCard Metadata Protobuf
  final Metadata metadata;
  final double iconSize;
  final double width;
  final double height;
  const MetaIcon({Key key, @required this.metadata, this.iconSize = 60, this.width = 150, this.height = 150}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      width: width,
      height: height,
      child: Container(
        decoration: Neumorph.floating(shape: BoxShape.circle),
        child: metadata.mime.type.gradient(size: iconSize),
      ),
    );
  }
}

///  Builds Container With Image as SizedBox
class MetaImageBox extends StatelessWidget {
  /// TransferCard Metadata Protobuf
  final Metadata metadata;
  final double width;
  final double height;
  final BoxFit fit;

  const MetaImageBox({Key key, @required this.metadata, this.width = 150, this.height = 150, this.fit = BoxFit.contain}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return metadata.isImage
        ? FutureBuilder<File>(
            initialData: null,
            future: MediaService.loadFileFromMetadata(metadata),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: Image.file(snapshot.data, fit: BoxFit.cover),
                );
              } else {
                return Container(
                  width: width,
                  height: height,
                  child: CircularProgressIndicator(),
                );
              }
            })
        : Container();
  }
}

/// Builds Metadata Video Player
class MetaVideo extends StatelessWidget {
  /// TransferCard Metadata Protobuf
  final Metadata metadata;
  final double width;
  final double height;
  final bool autoPlay;
  final bool allowScreenSleep;
  final bool looping;
  final MediaOrientation orientation;
  const MetaVideo({
    Key key,
    @required this.metadata,
    this.width,
    this.height,
    this.autoPlay = true,
    this.looping = true,
    this.allowScreenSleep = false,
    this.orientation = MediaOrientation.Portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return metadata.isVideo
        ? FutureBuilder<File>(
            initialData: null,
            future: MediaService.loadFileFromMetadata(metadata),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: width ?? orientation.defaultWidth,
                  height: height ?? orientation.defaultHeight,
                  child: BetterPlayer.file(snapshot.data.path,
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        controlsConfiguration: BetterPlayerControlsConfiguration(),
                        allowedScreenSleep: allowScreenSleep,
                        autoPlay: autoPlay,
                        looping: looping,
                        autoDetectFullscreenDeviceOrientation: true,
                        aspectRatio: orientation.aspectRatio,
                      )),
                );
              } else {
                return Container(
                  width: width ?? orientation.defaultWidth,
                  height: height ?? orientation.defaultHeight,
                  child: CircularProgressIndicator(),
                );
              }
            })
        : Container(
            width: width ?? orientation.defaultWidth,
            height: height ?? orientation.defaultHeight,
          );
  }
}
