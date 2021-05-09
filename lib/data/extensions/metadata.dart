import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

extension ProfileFileUtils on Profile {
  Widget get nameText {
    return " ${this.firstName} ${this.lastName}".h6;
  }
}

// @ Helper Enum for Video/Image Orientation
enum MediaOrientation { Portrait, Landscape }

extension MediaOrientationUtils on MediaOrientation {
  double get aspectRatio {
    switch (this) {
      case MediaOrientation.Landscape:
        return 16 / 9;
      default:
        return 9 / 16;
    }
  }

  double get defaultHeight {
    switch (this) {
      case MediaOrientation.Landscape:
        return 180;
      default:
        return 320;
    }
  }

  double get defaultWidth {
    switch (this) {
      case MediaOrientation.Landscape:
        return 320;
      default:
        return 180;
    }
  }
}
