import 'dart:async';
import 'dart:io';

import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/pages/overlay/overlay.dart';
import 'package:sonr_app/service/client/session.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';
export 'package:sonr_app/data/database/cards_db.dart';

class CardService extends GetxService {
  // Service Accessors
  static bool get isRegistered => Get.isRegistered<CardService>();
  static CardService get to => Get.find<CardService>();

  // File Objects
  final _activity = RxList<TransferActivity>();
  final _allCards = RxList<TransferCard>();
  final _contacts = RxList<TransferCard>();
  final _links = RxList<TransferCard>();
  final _files = RxList<TransferCard>();
  final _media = RxList<TransferCard>();
  final _categoryCount = RxInt(1);

  // File Count
  final _documentCount = 0.obs;
  final _otherCount = 0.obs;
  final _pdfCount = 0.obs;
  final _presentationCount = 0.obs;
  final _photosCount = 0.obs;
  final _spreadsheetCount = 0.obs;
  final _videosCount = 0.obs;

  // Property Accessors
  static RxList<TransferActivity> get activity => to._activity;
  static RxList<TransferCard> get all => to._allCards;
  static RxList<TransferCard> get contacts => to._contacts;
  static RxList<TransferCard> get links => to._links;
  static RxList<TransferCard> get files => to._files;
  static RxList<TransferCard> get media => to._media;

  // Count Accessors
  static RxInt get documentCount => to._documentCount;
  static RxInt get otherCount => to._otherCount;
  static RxInt get pdfCount => to._pdfCount;
  static RxInt get presentationCount => to._presentationCount;
  static RxInt get photosCount => to._photosCount;
  static RxInt get spreadsheetCount => to._spreadsheetCount;
  static RxInt get videosCount => to._videosCount;

  // Category Specific Count
  static bool get hasActivity => to._activity.length > 0;
  static bool get hasContacts => to._contacts.length > 0;
  static bool get hasFiles => to._files.length > 0;
  static bool get hasLinks => to._links.length > 0;
  static bool get hasMedia => to._media.length > 0;

  // Counts
  static int get totalCount => to._contacts.length + to._files.length + to._links.length + to._media.length;

  // References
  late CardsDatabase _database;

  // * Constructer * //
  Future<CardService> init() async {
    // Check Device
    if (DeviceService.isMobile) {
      // Set Database
      _database = CardsDatabase();

      // Bind Streams
      _activity.bindStream(_database.watchActivity());
      _allCards.bindStream(_database.watchAllCards());
      _media.bindStream(_database.watchMedia());
      _contacts.bindStream(_database.watchContacts());
      _files.bindStream(_database.watchFiles());
      _links.bindStream(_database.watchUrls());

      // Set Initial Counter
      int counter = 1;
      _contacts.length > 0 ? counter += 1 : counter += 0;
      _files.length > 0 ? counter += 1 : counter += 0;
      _links.length > 0 ? counter += 1 : counter += 0;
      _categoryCount(counter);
    }
    return this;
  }

  /// @ Add New Card to Database
  static addCard(Transfer card) async {
    if (isRegistered) {
      if (card.payload.isTransfer) {
        // Store in Database
        await to._database.addFileCard(card);
        _refreshCount();
      } else {
        // Store in Database
        await to._database.addCard(card);
        _refreshCount();
      }
    }
  }

  /// @ Add New Activity for deleted card
  static addActivityDeleted({
    required Payload payload,
    required Profile owner,
    SonrFile? file,
  }) async {
    if (isRegistered) {
      if (file != null && file.exists) {
        await to._database.addActivity(ActivityType.Deleted, payload, owner, mime: file.single.mime.type);
      } else {
        await to._database.addActivity(ActivityType.Deleted, payload, owner, mime: MIME_Type.OTHER);
      }
    }
  }

  /// @ Add New Activity for received card
  static addActivityReceived({
    required Payload payload,
    required Profile owner,
    SonrFile? file,
  }) async {
    if (isRegistered) {
      if (file != null && file.exists) {
        await to._database.addActivity(ActivityType.Received, payload, owner, mime: file.single.mime.type);
      } else {
        await to._database.addActivity(ActivityType.Received, payload, owner, mime: MIME_Type.OTHER);
      }
    }
  }

  /// @ Add New Activity for deleted card
  static addActivityShared({
    required Payload payload,
    SonrFile? file,
  }) async {
    if (isRegistered) {
      if (file != null && file.exists) {
        await to._database.addActivity(ActivityType.Shared, payload, UserService.contact.value.profile, mime: file.single.mime.type);
      } else {
        await to._database.addActivity(ActivityType.Shared, payload, UserService.contact.value.profile, mime: MIME_Type.OTHER);
      }
    }
  }

  /// @ Returns total Card Count
  static Future<int> cardCount({bool withoutContacts = false, bool withoutMedia = false, bool withoutURLs = false}) async {
    if (isRegistered) {
      // Get Total Entries
      var cards = await to._database.allCardEntries;

      // Filter from Options
      if (withoutContacts) {
        cards.removeWhere((element) => element.payload == Payload.CONTACT);
      }
      if (withoutMedia) {
        cards.removeWhere((element) => element.payload == Payload.FILE);
      }
      if (withoutURLs) {
        cards.removeWhere((element) => element.payload == Payload.URL);
      }

      // Return Remaining
      return cards.length;
    }
    return 0;
  }

  /// @ Clear Single Activity
  static clearActivity(TransferActivity activity) async {
    if (isRegistered) {
      if (hasActivity) {
        await to._database.clearActivity(activity);
      }
    }
  }

  /// @ Clear All Activity
  static clearAllActivity() async {
    if (isRegistered) {
      if (hasActivity) {
        await to._database.clearAllActivity();
      }
    }
  }

  /// @ Remove Card and Add Deleted Activity to Database
  static deleteCard(TransferCard card) async {
    if (isRegistered) {
      await to._database.deleteCard(card);
      addActivityDeleted(payload: card.payload, owner: card.owner, file: card.file);
      _refreshCount();
    }
  }

  /// @ Remove Card and Add Deleted Activity to Database
  static deleteCardFromID(int id) async {
    if (isRegistered) {
      await to._database.deleteCardFromID(id);
      _refreshCount();
    }
  }

  /// @ Remove Card and Add Deleted Activity to Database
  static deleteAllCards() async {
    if (isRegistered) {
      if (totalCount > 0) {
        await to._database.deleteAllCards();
      }
    }
  }

  /// @ Load IO File from Metadata
  static Future<File> loadFileFromMetadata(SonrFile_Item metadata) async {
    if (isRegistered) {
      var asset = await AssetEntity.fromId(metadata.id);
      if (asset != null) {
        var file = await asset.file;
        if (file != null) {
          return file;
        }
      }
      return metadata.file;
    } else {
      return File("");
    }
  }

  /// @ Load SonrFile from Metadata
  static Future<SonrFile> loadSonrFileFromMetadata(SonrFile_Item metadata) async {
    if (isRegistered) {
      return metadata.toSonrFile();
    } else {
      return SonrFile();
    }
  }

  /// @ Handles User Invite Response
  static handleInviteResponse(bool decision, InviteRequest invite, {bool sendBackContact = false, bool closeOverlay = false}) {
    if (isRegistered) {
      if (invite.payload == Payload.CONTACT) {
        to._handleAcceptContact(invite, sendBackContact);
      } else {
        decision ? to._handleAcceptTransfer(invite) : to._handleDeclineTransfer(invite);
      }
    }
  }

  static void reset() {
    if (isRegistered) {
      to._database.clearAllActivity();
      to._database.deleteAllCards();
    }
  }

  // @ Handle Accept Transfer Response
  _handleAcceptTransfer(InviteRequest invite) {
    // Check for Remote
    SonrService.respond(invite.newAcceptResponse());

    // Switch View
    SonrOverlay.back();
    SonrOverlay.show(
      ProgressView(invite.file, invite.file.single.size > 5000000),
      barrierDismissible: false,
      disableAnimation: true,
    );

    if (invite.file.single.size > 5000000) {
      // Handle Card Received
      SessionService.session.status.listen((s) {
        if (s.isCompleted) {
          SonrOverlay.back();
        }
      });
    } else {
      // Handle Animation Completed
      Future.delayed(1600.milliseconds, () {
        SonrOverlay.back();
      });
    }
  }

// @ Handle Decline Transfer Response
  _handleDeclineTransfer(InviteRequest invite) {
    SonrService.respond(invite.newDeclineResponse());
    SonrOverlay.back();
  }

// @ Handle Accept Contact Response
  _handleAcceptContact(InviteRequest invite, bool sendBackContact) {
    // Save Card
    _database.addCard(invite.data);

    // Check if Send Back
    if (sendBackContact) {
      SonrService.respond(invite.newAcceptResponse());
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home');
    }
  }

  // @ Helper: Refresh Category Count
  static void _refreshCount() {
    // Set Category Count
    int counter = 1;
    hasContacts ? counter += 1 : counter += 0;
    hasFiles ? counter += 1 : counter += 0;
    hasLinks ? counter += 1 : counter += 0;
    to._categoryCount(counter);

    // Set Individual File Count
    if (hasFiles) {
      to._documentCount(to._files.count((i) => i.mime == MIME_Type.TEXT));
      to._pdfCount(to._files.count((i) => i.mime == MIME_Type.PDF));
      to._presentationCount(to._files.count((i) => i.mime == MIME_Type.PRESENTATION));
      to._spreadsheetCount(to._files.count((i) => i.mime == MIME_Type.SPREADSHEET));
      to._otherCount(to._files.count((i) => i.mime == MIME_Type.OTHER));
      to._photosCount(to._files.count((i) => i.mime == MIME_Type.IMAGE));
      to._videosCount(to._files.count((i) => i.mime == MIME_Type.VIDEO));
    }
  }
}
