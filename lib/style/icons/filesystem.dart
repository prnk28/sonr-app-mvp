import 'icons.dart';

enum FileSystemIcons {
  /// ### [Uni_icons: FileSystem] - FileArchive
  /// !["Icon of FileArchive"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-archive.svg)
  FileArchive,

  /// ### [Uni_icons: FileSystem] - FileChartLine
  /// !["Icon of FileChartLine"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-chart-line.svg)
  FileChartLine,

  /// ### [Uni_icons: FileSystem] - FileCode
  /// !["Icon of FileCode"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-code.svg)
  FileCode,

  /// ### [Uni_icons: FileSystem] - FileChartColumn
  /// !["Icon of FileChartColumn"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-chart-column.svg)
  FileChartColumn,

  /// ### [Uni_icons: FileSystem] - FileImageOne
  /// !["Icon of FileImageOne"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-image-01.svg)
  FileImageOne,

  /// ### [Uni_icons: FileSystem] - FileAudio
  /// !["Icon of FileAudio"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-audio.svg)
  FileAudio,

  /// ### [Uni_icons: FileSystem] - FileInfo
  /// !["Icon of FileInfo"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-info.svg)
  FileInfo,

  /// ### [Uni_icons: FileSystem] - FileList
  /// !["Icon of FileList"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-list.svg)
  FileList,

  /// ### [Uni_icons: FileSystem] - FileLocation
  /// !["Icon of FileLocation"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-location.svg)
  FileLocation,

  /// ### [Uni_icons: FileSystem] - FileImageTwo
  /// !["Icon of FileImageTwo"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-image-02.svg)
  FileImageTwo,

  /// ### [Uni_icons: FileSystem] - FileMusic
  /// !["Icon of FileMusic"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-music.svg)
  FileMusic,

  /// ### [Uni_icons: FileSystem] - FileTextTwo
  /// !["Icon of FileTextTwo"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-text-02.svg)
  FileTextTwo,

  /// ### [Uni_icons: FileSystem] - FileVideo
  /// !["Icon of FileVideo"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-video.svg)
  FileVideo,

  /// ### [Uni_icons: FileSystem] - FolderArchive
  /// !["Icon of FolderArchive"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/folder-archive.svg)
  FolderArchive,

  /// ### [Uni_icons: FileSystem] - FileUser
  /// !["Icon of FileUser"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-user.svg)
  FileUser,

  /// ### [Uni_icons: FileSystem] - FileTable
  /// !["Icon of FileTable"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-table.svg)
  FileTable,

  /// ### [Uni_icons: FileSystem] - FileTextOne
  /// !["Icon of FileTextOne"](/Users/prad/Sonr/tools/icons/assets/solid/FileSystem/file-text-01.svg)
  FileTextOne,
}

extension FileSystemIconUtils on FileSystemIcons {
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
