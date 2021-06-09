import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:sonr_app/style.dart';
import 'package:file_picker/file_picker.dart';

/// @ Class for Managing Files
class TransferService extends GetxService {
  // Status
  static bool get isRegistered => Get.isRegistered<TransferService>();
  static TransferService get to => Get.find<TransferService>();

  // Properties
  final _hasPayload = false.obs;
  final _payload = Payload.NONE.obs;
  final _invite = AuthInvite().obs;
  final _sonrFile = SonrFile().obs;
  final _sessions = Queue<Session>().obs;
  final _thumbStatus = ThumbnailStatus.None.obs;

  // Property Accessors
  static Rx<Payload> get payload => to._payload;
  static Rx<AuthInvite> get inviteRequest => to._invite;
  static Rx<SonrFile> get file => to._sonrFile;
  static Rx<ThumbnailStatus> get thumbStatus => to._thumbStatus;
  static RxBool get hasPayload => to._hasPayload;
  static Rx<Queue> get sessions => to._sessions;

  /// @ Initialize Service
  Future<TransferService> init() async {
    return this;
  }

  // @ Use Camera for Media File //
  static Future<bool> chooseCamera() async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-Camera',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    // Initialize
    Completer<bool> completer = Completer<bool>();
    // Move to View
    CameraView.open(onMediaSelected: (SonrFile file) async {
      var result = await _handlePayload(Payload.MEDIA, file: file);

      // Analytics
      FirebaseAnalytics().logEvent(
        name: '[TransferService]: Confirmed-Camera',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': DeviceService.device.platform.toString(),
        },
      );

      // Complete Result
      completer.complete(result);
    });
    return completer.future;
  }

  // @ Set User Contact for Transfer //
  static Future<bool> chooseContact() async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-Contact',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    return await _handlePayload(Payload.CONTACT);
  }

  // @ Select Media File //
  static Future<bool> chooseMedia({bool withRedirect = true}) async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-Media',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      // Analytics
      FirebaseAnalytics().logEvent(
        name: '[TransferService]: Confirm-Media',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': DeviceService.device.platform.toString(),
        },
      );

      // Convert To File
      var file = result.toSonrFile(payload: Payload.MEDIA);
      return await _handlePayload(file.payload, file: file);
    }
    return false;
  }

  // @ Select Other File //
  static Future<bool> chooseFile() async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-File',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    // Load Picker
    var result = await _handleSelectRequest(FileType.any);

    // Check File
    if (result != null) {
      // Analytics
      FirebaseAnalytics().logEvent(
        name: '[TransferService]: Confirm-File',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': DeviceService.device.platform.toString(),
        },
      );

      // Confirm File
      var file = result.toSonrFile(payload: Payload.FILE);
      return await _handlePayload(file.payload, file: file);
    }
    return false;
  }

  /// @ Resets Transfer Service
  static Future<void> resetPayload() async {
    to._hasPayload(false);
    to._payload(Payload.NONE);
    to._invite(AuthInvite());
    to._sonrFile(SonrFile());
    to._thumbStatus(ThumbnailStatus.None);
  }

  // @ Select Media File //
  static Future<bool> setUrl(String url) async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-URL',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );
    return await _handlePayload(Payload.URL, url: url);
  }

  // @ Select Media File //
  static Future<bool> setMedia(SonrFile file) async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-Media',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    return await _handlePayload(file.payload, file: file);
  }

  /// @ Send Invite with Peer
  static Session? sendInviteToPeer(Peer peer) {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Selected-Peer',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'peer-platform': peer.platform.toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    // Check if Payload Set
    if (to._hasPayload.value) {
      // Update Request
      to._invite.setPeer(peer);

      // Send Invite
      return SonrService.invite(to._invite.value);
    }
    return null;
  }

  /// @ Sets File from Other Source
  static Future<bool> setFile(SonrFile file) async {
    // Analytics
    FirebaseAnalytics().logEvent(
      name: '[TransferService]: Choose-File',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'payload': file.payload.toString(),
        'platform': DeviceService.device.platform.toString(),
      },
    );

    // Handle File Payload
    return await _handlePayload(file.payload, file: file);
  }

  /// @ Write Uint8List Image Data to Storage
  static Future<String> writeImageToStorage(Uint8List data) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(data);
    return screenshotFilePath;
  }

  /// Set Transfer Payload for File
  static Future<bool> _handlePayload(Payload payload, {SonrFile? file, String? url}) async {
    // Initialize Request
    to._payload(payload);

    // @ Handle Payload
    if (to._payload.value.isTransfer && file != null) {
      // Capture File Analytics
      FirebaseAnalytics().logEvent(
        name: '[TransferService]: Shared-File',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': DeviceService.device.platform.toString(),
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

      // Check valid File Size Payload
      if (file.size > 0) {
        file.update();
        to._invite.init(payload, file: file);
        to._sonrFile(file);

        // Check for Media
        if (to._invite.isMedia) {
          // Set File Item
          to._thumbStatus(ThumbnailStatus.Loading);
          await to._sonrFile.value.setThumbnail();

          // Check Result
          if (to._sonrFile.value.single.hasThumbnail()) {
            to._thumbStatus(ThumbnailStatus.Complete);
          } else {
            to._thumbStatus(ThumbnailStatus.None);
          }
        }

        // Set Has Payload
        to._hasPayload(true);
      }
    }
    // Check for Contact
    else if (to._payload.value == Payload.CONTACT) {
      // Capture Contact Analytics
      FirebaseAnalytics().logEvent(
        name: '[TransferService]: Shared-Contact',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': DeviceService.device.platform.toString(),
          'payload': Payload.CONTACT.toString(),
        },
      );

      // Initialize Contact
      to._invite.init(payload, contact: UserService.contact.value);

      // Set Has Payload
      to._hasPayload(true);
    }
    // Check for URL
    else if (to._payload.value == Payload.URL) {
      // Capture Contact Analytics
      FirebaseAnalytics().logEvent(
        name: '[TransferService]: Shared-Contact',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': DeviceService.device.platform.toString(),
          'link': url,
          'payload': Payload.URL.toString(),
        },
      );

      // Initialize URL
      to._invite.init(payload, url: url!);

      // Set Has Payload
      to._hasPayload(true);
    }

    // @ Check if Payload Set
    if (!to._hasPayload.value) {
      to._payload(Payload.NONE);
      to._hasPayload(false);
    }
    return to._hasPayload.value;
  }

  // # Generic Method for Different File Types
  static Future<FilePickerResult?> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    // Check Type for Custom Files
    if (type == FileType.any) {
      return await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );
    }

    // For Media/Audio Files
    else {
      return await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );
    }
  }
}
