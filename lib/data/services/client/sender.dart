import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:sonr_app/modules/authorize/authorize.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';

class SenderService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SenderService>();
  static SenderService get to => Get.find<SenderService>();

  // @ Properties
  final Session _session = Session();
  final _hasSession = false.obs;

  /// Returns Current Session
  static Session get session => to._session;
  static Rx<bool> get hasSession => to._hasSession;

  // ^ Constructer ^ //
  Future<SenderService> init() async {
    return this;
  }

  // * ------------------- Methods ----------------------------
  /// Method to Choose Option to Share
  static Future<InviteRequest?> choose(ChooseOption option, {SonrFile? file}) async {
    if (isRegistered) {
      // Log Choice
      option.logChoice();

      // Check for Provided File
      if (file != null) {
        return await to._handlePayload(file.payload, file: file);
      }
      // Continue with Picker
      else {
        // Handle Request
        switch (option) {
          case ChooseOption.Camera:
            return await to._handleCameraChoice();
          case ChooseOption.Contact:
            return await to._handleContactChoice();
          case ChooseOption.Media:
            return await to._handleFileChoice();
          case ChooseOption.File:
            return await to._handleMediaChoice();
        }
      }
    }
  }

  /// @ Send Invite with Peer
  static Session? invite(InviteRequest request) {
    // Verify Request
    if (!request.payload.isNone && request.hasTo()) {
      // Analytics
      Logger.event(
        name: 'selectedPeer',
        controller: 'SenderService',
        parameters: {
          'peerPlatform': request.to.platform.toString(),
        },
      );

      // Send Invite
      NodeService.to.node.invite(request);
      to._session.outgoing(request);
      return to._session;
    }
    return null;
  }

  // * ------------------- Callbacks ----------------------------
  /// Peer has Responded
  void handleReply(InviteResponse data) async {
    // Logging
    Logger.info("Node(Callback) Responded: " + data.toString());

    // Handle Contact Response
    if (data.type == InviteResponse_Type.Contact) {
      await HapticFeedback.heavyImpact();

      // Check if Flat Mode
      data.flatMode ? FlatMode.response(data.transfer.contact) : Authorize.reply(data);
    }

    // For Cancel
    else if (data.type == InviteResponse_Type.Cancel) {
      await HapticFeedback.vibrate();
    } else {
      _session.onReply(data);
    }
  }

  /// User has shared file succesfully
  void handleTransmitted(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);

    // Feedback
    DeviceService.playSound(type: UISoundType.Transmitted);
    await HapticFeedback.heavyImpact();

    // Logging Activity
    CardService.addActivity(
      payload: data.payload,
      file: data.file,
      type: ActivityType.Shared,
    );

    // Logging
    Logger.info("Node(Callback) Transmitted: " + data.toString());
    _hasSession(false);
    _session.reset();
  }

  // * ------------------- Helpers ----------------------------
  // @ Helper: Handles CAMERA Choice
  Future<InviteRequest?> _handleCameraChoice() async {
    if (DeviceService.isMobile) {
      // Move to View
      CameraView.open(onMediaSelected: (SonrFile file) async {
        var result = await _handlePayload(Payload.MEDIA, file: file);

        // Analytics
        ChooseOption.Camera.logConfirm();

        // Complete Result
        return result;
      });
    }
    return null;
  }

  // @ Helper: Handles CONTACT Choice
  Future<InviteRequest?> _handleContactChoice() async {
    return await _handlePayload(Payload.CONTACT);
  }

  // @ Helper: Handles FILE Choice
  Future<InviteRequest?> _handleFileChoice() async {
    // Load Picker
    if (DeviceService.isMobile) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        // Analytics
        if (DeviceService.isMobile) {
          ChooseOption.File.logConfirm();
        }

        // Confirm File
        var file = result.toSonrFile(payload: Payload.FILE);
        return await _handlePayload(file.payload, file: file);
      } else {
        var filePath = await NodeService.to.node.pickFile();
        var file = SonrFile(payload: Payload.FILE, items: [SonrFile_Item(path: filePath)], count: 1);
        if (filePath != null) {
          return await _handlePayload(file.payload, file: file);
        }
      }
    }
  }

  // @ Helper: Handles MEDIA Choice
  Future<InviteRequest?> _handleMediaChoice() async {
    if (DeviceService.isMobile) {
      // Load Picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );

      // Check File
      if (result != null) {
        // Analytics
        if (DeviceService.isMobile) {
          ChooseOption.Media.logConfirm();
        }
        // Convert To File
        var file = result.toSonrFile(payload: Payload.MEDIA);
        return await _handlePayload(file.payload, file: file);
      }
    }
  }

  /// @ Helper: Creates Invite Request from Payload
  Future<InviteRequest> _handlePayload(Payload payload, {SonrFile? file, String? url}) async {
    // Initialize
    InviteRequest invite = InviteRequest();

    // @ Handle Payload
    if (payload.isTransfer && file != null) {
      // Capture File Analytics
      ChooseOption.File.logShared(file: file);

      // Check valid File Size Payload
      if (file.size > 0) {
        file.update();
        invite.setFile(file);

        // Check for Media
        if (invite.payload.isMedia) {
          // Set File Item
          await file.setThumbnail();
        }
      }
    }
    // Check for Contact
    else if (payload == Payload.CONTACT) {
      // Capture Analytics
      ChooseOption.Contact.logShared();

      // Initialize Contact
      invite.setContact(ContactService.contact.value);
    }
    // Check for URL
    else if (payload == Payload.URL) {
      // Capture Contact Analytics
      Logger.event(
        name: 'sharedURL',
        controller: 'SenderService',
        parameters: {
          'link': url,
          'payload': Payload.URL.toString(),
        },
      );

      // Initialize URL
      invite.setUrl(url!);
    }
    return invite;
  }
}
