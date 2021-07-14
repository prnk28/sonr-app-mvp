import 'dart:async';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

class CardService extends GetxService {
  // Service Accessors
  static bool get isRegistered => Get.isRegistered<CardService>();
  static CardService get to => Get.find<CardService>();
  final _database = CardsDatabase();

  // File Objects
  final _activity = RxList<TransferActivity>();
  final _allCards = RxList<TransferCard>();
  final _contacts = RxList<TransferCard>();
  final _links = RxList<TransferCard>();
  final _files = RxList<TransferCard>();
  final _media = RxList<TransferCard>();

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

  // * Constructer * //
  Future<CardService> init() async {
    // Check Device
    if (DeviceService.isMobile) {
      // Bind Streams
      _activity.bindStream(_database.watchActivity());
      _allCards.bindStream(_database.watchAllCards());
      _media.bindStream(_database.watchMedia());
      _contacts.bindStream(_database.watchContacts());
      _files.bindStream(_database.watchFiles());
      _links.bindStream(_database.watchUrls());
    }
    return this;
  }

  // * Initializer * //
  @override
  onInit() {
    // Set Individual File Count
    if (_files.length > 0) {
      // Check Mime Count
      int docsCount = 0;
      int pdfsCount = 0;
      int presentationCount = 0;
      int spreadsheetCount = 0;
      int otherCount = 0;
      int photosCount = 0;
      int videosCount = 0;

      // Check File Types
      _files.forEach((i) {
        if (i.file != null) {
          i.file!.items.forEach((i) {
            // Text/Docs
            if (i.mime.isText || i.mime.isDoc) {
              docsCount += 1;
            }
            // PDFs
            else if (i.mime.isPDF) {
              pdfsCount += 1;
            }
            // Presentations
            else if (i.mime.isPresentation) {
              presentationCount += 1;
            }
            // Spreadsheets
            else if (i.mime.isSpreadsheet) {
              spreadsheetCount += 1;
            }
            // Images
            else if (i.mime.isImage) {
              photosCount += 1;
            }
            // Videos
            else if (i.mime.isVideo) {
              videosCount += 1;
            }
            // Other
            else if (i.mime.isOther) {
              otherCount += 1;
            }
          });
        }
      });

      // Set Counts
      _documentCount(docsCount);
      _pdfCount(pdfsCount);
      _presentationCount(presentationCount);
      _spreadsheetCount(spreadsheetCount);
      _otherCount(otherCount);
      _photosCount(photosCount);
      _videosCount(videosCount);
    }
    super.onInit();
  }

  /// #### Add New Card to Database
  static addCard(Transfer card, ActivityType activityType) async {
    // Update Database
    if (DeviceService.isMobile && isRegistered) {
      // Store in Database
      await to._database.addCard(card);
      await to._database.addActivity(activityType, card.payload, card.owner);
      _refreshCount();
    }
  }

  /// #### Add New Activity for deleted card
  static addActivity({
    required ActivityType type,
    required Payload payload,
    SFile? file,
  }) async {
    if (DeviceService.isMobile && isRegistered) {
      if (file != null && file.exists) {
        await to._database.addActivity(type, payload, ContactService.contact.value.profile, mime: file.single.mime.type);
      } else {
        await to._database.addActivity(type, payload, ContactService.contact.value.profile, mime: MIME_Type.OTHER);
      }
    }
  }

  /// #### Returns total Card Count
  static Future<int> cardCount({bool withoutContacts = false, bool withoutMedia = false, bool withoutURLs = false}) async {
    if (DeviceService.isMobile && isRegistered) {
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

  /// #### Clear Single Activity
  static clearActivity(TransferActivity activity) async {
    if (DeviceService.isMobile && isRegistered) {
      if (hasActivity) {
        await to._database.clearActivity(activity);
      }
    }
  }

  /// #### Clear All Activity
  static clearAllActivity() async {
    if (DeviceService.isMobile && isRegistered) {
      if (hasActivity) {
        await to._database.clearAllActivity();
      }
    }
  }

  /// #### Remove Card and Add Deleted Activity to Database
  static deleteCard(TransferCard card) async {
    if (DeviceService.isMobile && isRegistered) {
      await to._database.deleteCard(card);
      if (card.file != null) {
        await to._database.addActivity(ActivityType.Deleted, card.payload, card.owner, mime: card.file!.single.mime.type);
      } else {
        await to._database.addActivity(ActivityType.Deleted, card.payload, card.owner);
      }
      _refreshCount();
    }
  }

  /// #### Remove Card and Add Deleted Activity to Database
  static deleteCardFromID(int id) async {
    if (DeviceService.isMobile && isRegistered) {
      await to._database.deleteCardFromID(id);
      _refreshCount();
    }
  }

  /// #### Remove Card and Add Deleted Activity to Database
  static deleteAllCards() async {
    if (DeviceService.isMobile && isRegistered) {
      if (totalCount > 0) {
        await to._database.deleteAllCards();
      }
    }
  }

  // @ Helper: Refresh Category Count
  static void _refreshCount() {
    if (DeviceService.isMobile && isRegistered) {
      // Set Individual File Count
      if (hasFiles) {
        // Check Mime Count
        int docsCount = 0;
        int pdfsCount = 0;
        int presentationCount = 0;
        int spreadsheetCount = 0;
        int otherCount = 0;
        int photosCount = 0;
        int videosCount = 0;

        // Check File Types
        to._files.forEach((i) {
          if (i.file != null) {
            i.file!.items.forEach((i) {
              // Text/Docs
              if (i.mime.isText || i.mime.isDoc) {
                docsCount += 1;
              }
              // PDFs
              else if (i.mime.isPDF) {
                pdfsCount += 1;
              }
              // Presentations
              else if (i.mime.isPresentation) {
                presentationCount += 1;
              }
              // Spreadsheets
              else if (i.mime.isSpreadsheet) {
                spreadsheetCount += 1;
              }
              // Images
              else if (i.mime.isImage) {
                photosCount += 1;
              }
              // Videos
              else if (i.mime.isVideo) {
                videosCount += 1;
              }
              // Other
              else if (i.mime.isOther) {
                otherCount += 1;
              }
            });
          }
        });

        // Set Counts
        to._documentCount(docsCount);
        to._pdfCount(pdfsCount);
        to._presentationCount(presentationCount);
        to._spreadsheetCount(spreadsheetCount);
        to._otherCount(otherCount);
        to._photosCount(photosCount);
        to._videosCount(videosCount);
      }
    }
  }
}
