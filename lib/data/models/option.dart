import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:soundpool/soundpool.dart';

/// Option for Share Choice
enum ChooseOption { Camera, Contact, Media, File }

/// #### Extension for (General) Choose Option
extension ChooseOptionUtils on ChooseOption {
  /// Reference to LogController
  static String LOG_CONTROLLER = "ShareController";

  /// Returns Option Name without Prefix
  String get name => this.toString().substring(this.toString().indexOf('.') + 1);

  /// Logs Chosen Option in Analytics
  void logChoice() {
    // Run Action
    Logger.event(
      controller: LOG_CONTROLLER,
      name: "choose$name",
    );
  }

  /// Logs Chosen Option in Analytics -- From Set
  void logChooseFile(SFile file) {
    // Run Action
    Logger.event(
      controller: LOG_CONTROLLER,
      name: "choose$name",
      parameters: {
        'payload': file.payload.toString(),
      },
    );
  }

  /// Logs Confirmed Option in Analytics
  void logConfirm() {
    // Run Action
    Logger.event(
      controller: LOG_CONTROLLER,
      name: "confirm$name",
    );
  }

  /// Logs Confirmed Option in Analytics
  void logSetPeer(Peer peer) {
    // Analytics
    Logger.event(
      name: 'setPeer',
      controller: LOG_CONTROLLER,
      parameters: {
        'peerPlatform': peer.platform.toString(),
        'chosenOption': "$name",
      },
    );
  }

  /// Logs Shared Option in Analytics
  void logShared({SFile? file, String? url}) {
    // @ Run File Action
    if (file != null) {
      Logger.event(
        controller: LOG_CONTROLLER,
        name: "shared$name",
        parameters: {
          'totalSize': file.size,
          'count': file.count,
          'payload': file.payload.toString(),
          'items': List.generate(
              file.count,
              (index) => {
                    'mimeValue': file.items[index].mime.value,
                    'mimeSubtype': file.items[index].mime.subtype,
                    'size': file.items[index].size,
                  })
        },
      );
    }

    // @ Run URL Action
    else if (url != null) {
      Logger.event(
        controller: LOG_CONTROLLER,
        name: "shared$name",
        parameters: {
          'link': url,
          'payload': Payload.URL.toString(),
        },
      );
    }

    // @ Run DEFAULT Action
    else {
      Logger.event(
        controller: LOG_CONTROLLER,
        name: "shared$name",
      );
    }
  }
}

/// @ Asset Sound Types
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
  static late Soundpool _pool;

  /// Map with Sound Type and ID
  static Map<Sound, int> _soundIds = {};

  /// Initialize Soundpool
  static Future<void> init() async {
    if (isCompatible) {
      // Init Pool
      _pool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));

      // Add Sounds
      for (Sound s in Sound.values) {
        int soundId = await rootBundle.load(s.path).then((ByteData soundData) {
          return _pool.load(soundData);
        });
        _soundIds[s] = soundId;
      }
    }
  }

  /// Play this Current Sound
  Future<void> play() async {
    if (isCompatible && _soundIds[this] != null) {
      await _pool.play(_soundIds[this]!);
      await _pool.release();
    }
  }

  /// Return File Name of Sound
  String get file {
    return '${this.name.toLowerCase()}.wav';
  }

  /// Return Full Path of File
  String get path {
    return 'assets/sounds/$file';
  }

  /// Return Enum Value as String without Prefix
  String get name {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
