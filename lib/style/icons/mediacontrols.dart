import 'icons.dart';

enum MediaControlIcons {
  /// ### [Uni_icons: MediaControls] - Airplay
  /// !["Icon of Airplay"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/airplay.svg)
  Airplay,

  /// ### [Uni_icons: MediaControls] - BackwardOne
  /// !["Icon of BackwardOne"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/backward-01.svg)
  BackwardOne,

  /// ### [Uni_icons: MediaControls] - AlbumLibrary
  /// !["Icon of AlbumLibrary"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/album-library.svg)
  AlbumLibrary,

  /// ### [Uni_icons: MediaControls] - BackwardTwo
  /// !["Icon of BackwardTwo"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/backward-02.svg)
  BackwardTwo,

  /// ### [Uni_icons: MediaControls] - AudioLibrary
  /// !["Icon of AudioLibrary"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/audio-library.svg)
  AudioLibrary,

  /// ### [Uni_icons: MediaControls] - BrightnessDown
  /// !["Icon of BrightnessDown"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/brightness-down.svg)
  BrightnessDown,

  /// ### [Uni_icons: MediaControls] - BrightnessUp
  /// !["Icon of BrightnessUp"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/brightness-up.svg)
  BrightnessUp,

  /// ### [Uni_icons: MediaControls] - CloseCrFr
  /// !["Icon of CloseCrFr"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/close-cr-fr.svg)
  CloseCrFr,

  /// ### [Uni_icons: MediaControls] - Eject
  /// !["Icon of Eject"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/eject.svg)
  Eject,

  /// ### [Uni_icons: MediaControls] - ExitFullScreen
  /// !["Icon of ExitFullScreen"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/exit-full-screen.svg)
  ExitFullScreen,

  /// ### [Uni_icons: MediaControls] - FastBackward
  /// !["Icon of FastBackward"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/fast-backward.svg)
  FastBackward,

  /// ### [Uni_icons: MediaControls] - FastForward
  /// !["Icon of FastForward"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/fast-forward.svg)
  FastForward,

  /// ### [Uni_icons: MediaControls] - ForwardTwo
  /// !["Icon of ForwardTwo"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/forward-02.svg)
  ForwardTwo,

  /// ### [Uni_icons: MediaControls] - FullScreen
  /// !["Icon of FullScreen"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/full-screen.svg)
  FullScreen,

  /// ### [Uni_icons: MediaControls] - ForwardOne
  /// !["Icon of ForwardOne"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/forward-01.svg)
  ForwardOne,

  /// ### [Uni_icons: MediaControls] - MicrophoneOff
  /// !["Icon of MicrophoneOff"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/microphone-off.svg)
  MicrophoneOff,

  /// ### [Uni_icons: MediaControls] - Microphone
  /// !["Icon of Microphone"](/Users/prad/Sonr/tools/icons/assets/solid/MediaControls/microphone.svg)
  Microphone,
}

extension MediaControlsUtils on MediaControlIcons {
  /// Returns Raw Type of Enum
  String get type => this.toString().substring(0, this.toString().indexOf('.'));

  /// Returns Directory of Category
  String get category => this.type.replaceAll('Icons', '');

  /// Returns Raw Value of Enum Type
  String get value => this.toString().substring(this.toString().indexOf('.') + 1);

  /// Returns this Icons File Name
  String get fileName {
    // Set Base Path
    var path = '';

    // Iterate Words
    bool isFirst = true;
    for (var word in this.pascalWords) {
      // Verify Value
      if (word != null) {
        // Check if first element
        if (isFirst) {
          path += cleanWord(word);
          isFirst = false;
        }
        // Add Hyphen for consecutive words
        else {
          path += "-${cleanWord(word)}";
        }
      }
    }

    return path;
  }

  /// Returns Path for this Icon by Fill
  String path(IconFill fill) {
    return 'assets/icons/${category}/${this.fileName}@${fill.name}.svg';
  }

  /// ## (SVG) ChartIcons:DuoTone
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture duoTone({
    Key? key,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.DuoTone),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      colorBlendMode: BlendMode.overlay,
      alignment: alignment,
    );
  }

  /// ## (SVG) ChartIcons:Line
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture line({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.Line),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// ## (SVG) ChartIcons:Solid
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture solid({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.Solid),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// Get All pascal words in Enum Value
  List<String?> get pascalWords => K_PASCAL_REGEX.allMatches(this.value).map((m) => m[0]).toList();

  /// #### Constant Regex Expression for Fuzzy Path
  static final K_PASCAL_REGEX = RegExp(r"(?:[A-Z]+|^)[a-z]*");
}
