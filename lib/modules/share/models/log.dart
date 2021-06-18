import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style.dart';

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
  void logChooseFile(SonrFile file) {
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
  void logShared({SonrFile? file, String? url}) {
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
