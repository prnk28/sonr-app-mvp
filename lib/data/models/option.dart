import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// Option for Share Choice
enum ChooseOption { Camera, Contact, Media, File }

/// #### Extension for (General) Choose Option
extension ChooseOptionUtils on ChooseOption {
  /// Reference to LogController
  static String LOG_CONTROLLER = "ShareController";

  /// Returns Option Name without Prefix
  String get name => this.toString().substring(this.toString().indexOf('.') + 1);
}

/// #### Asset Sound Types
enum Sound {
  Confirmed,
  Connected,
  Critical,
  Deleted,
  Fatal,
  Joined,
  Linked,
  Received,
  Swipe,
  Transmitted,
  Warning,
}

// @ Asset Sound Type Utility
extension Sounds on Sound {
  /// Checks if Platform can play Sounds
  static bool get isCompatible => (PlatformUtils.find().isMobile || PlatformUtils.find().isWeb || PlatformUtils.find().isMacOS);

  /// Constant Soundpool Reference
  //static late Soundpool _pool;

  /// Map with Sound Type and ID
  static Map<Sound, int> _soundIds = {};

  /// Initialize Soundpool
  static Future<void> init() async {
    if (isCompatible) {
      // Init Pool
     // _pool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));

      // Add Sounds
      // for (Sound s in Sound.values) {
      //   int soundId = await rootBundle.load(s.path).then((ByteData soundData) {
      //  //   return _pool.load(soundData);
      //   });
      //   _soundIds[s] = soundId;
      // }
    }
  }

  /// Play this Current Sound
  Future<void> play() async {
    if (isCompatible && _soundIds[this] != null) {
      // await _pool.play(_soundIds[this]!);
      // await _pool.release();
    }
  }

  /// Return File Name of Sound
  String get file => '${this.name.toLowerCase()}.wav';

  /// Return Full Path of File
  String get path => 'assets/sounds/$file';

  /// Return Enum Value as String without Prefix
  String get name => this.toString().substring(this.toString().indexOf('.') + 1);
}

// @ Intercom Carousel Option
enum IntercomCarousel {
  /// Software Update v0.9.4
  Update94,
}

extension IntercomCarouselUtils on IntercomCarousel {
  /// Returns Carousel ID by Option
  String get id {
    switch (this) {
      case IntercomCarousel.Update94:
        return '20299209';
    }
  }

  /// Method Displays Intercom Carousel
  Future<void> show() async {
    await Intercom.displayCarousel(this.id);
  }
}
