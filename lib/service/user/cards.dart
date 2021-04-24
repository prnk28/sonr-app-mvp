import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/modules/overlay/overlay.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';
export 'package:sonr_app/data/database/cards_db.dart';

class CardService extends GetxService {
  // Service Accessors
  static bool get isRegistered => Get.isRegistered<CardService>();
  static CardService get to => Get.find<CardService>();

  // Properties
  final _activity = RxList<TransferCardActivity>();
  final _all = RxList<TransferCardItem>();
  final _contacts = RxList<TransferCardItem>();
  final _files = RxList<TransferCardItem>();
  final _links = RxList<TransferCardItem>();
  final _media = RxList<TransferCardItem>();

  // Property Accessors
  static RxList<TransferCardActivity> get activity => to._activity;
  static RxList<TransferCardItem> get all => to._all;
  static RxList<TransferCardItem> get contacts => to._contacts;
  static RxList<TransferCardItem> get files => to._files;
  static RxList<TransferCardItem> get links => to._links;
  static RxList<TransferCardItem> get media => to._media;

  // Category Specific Count
  static bool get hasActivity => to._activity.length > 0;
  static bool get hasContacts => to._contacts.length > 0;
  static bool get hasFiles => to._files.length > 0;
  static bool get hasLinks => to._links.length > 0;
  static bool get hasMedia => to._media.length > 0;

  // Total Count
  static int get categoryCount {
    int counter = 1;
    hasContacts ? counter += 1 : counter += 0;
    hasFiles ? counter += 1 : counter += 0;
    hasMedia ? counter += 1 : counter += 0;
    hasLinks ? counter += 1 : counter += 0;
    return counter;
  }

  // References
  final _database = CardsDatabase();

  // * Constructer * //
  Future<CardService> init() async {
    _activity.bindStream(_database.watchActivity());
    _all.bindStream(_database.watchAll());
    _contacts.bindStream(_database.watchContacts());
    _files.bindStream(_database.watchFiles());
    _media.bindStream(_database.watchMedia());
    _links.bindStream(_database.watchUrls());
    return this;
  }

  // ^ Add New Card to Database ^ //
  static addCard(TransferCard card) async {
    // Save Media to Device
    if (card.payload == Payload.MEDIA) {
      var asset = await MediaService.saveTransfer(card.metadata);
      if (asset != null) {
        card.metadata.id = asset.id;
      }
    }

    // Store in Database
    await to._database.addCard(card);
    await to._database.addActivity(ActivityType.Received, card);
  }

  // ^ Returns total Card Count ^ //
  static Future<int> cardCount({bool withoutContacts = false, bool withoutMedia = false, bool withoutURLs = false}) async {
    // Get Total Entries
    var cards = await to._database.allCardEntries;

    // Filter from Options
    if (withoutContacts) {
      cards.removeWhere((element) => element.payload == Payload.CONTACT);
    }
    if (withoutMedia) {
      cards.removeWhere((element) => element.payload == Payload.MEDIA);
    }
    if (withoutURLs) {
      cards.removeWhere((element) => element.payload == Payload.URL);
    }

    // Return Remaining
    return cards.length;
  }

  // ^ Remove Card and Add Deleted Activity to Database ^ //
  static deleteCard(TransferCardItem card) async {
    await to._database.deleteCard(card);
    await to._database.addActivity(ActivityType.Deleted, _transferCardFromItem(card));
  }

  // ^ Add Shared Card to Activity Datavase
  static sharedCard(TransferCard card) async {
    await to._database.addActivity(ActivityType.Shared, card);
  }

  // ^ Handles User Invite Response
  static handleInviteResponse(bool decision, AuthInvite invite, TransferCard card, {bool sendBackContact = false, bool closeOverlay = false}) {
    if (invite.payload == Payload.CONTACT) {
      to._handleAcceptContact(invite, card, sendBackContact);
    } else {
      decision ? to._handleAcceptTransfer(invite, card) : to._handleDeclineTransfer(invite);
    }
  }

  // @ Handle Accept Transfer Response
  _handleAcceptTransfer(AuthInvite invite, TransferCard card) {
    // Check for Remote
    if (invite.hasRemote()) {
      SonrService.respond(true, info: invite.remote);
    } else {
      SonrService.respond(true);
    }

    // Switch View
    SonrOverlay.back();
    SonrOverlay.show(
      ProgressView(card, card.metadata.size > 5000000),
      barrierDismissible: false,
      disableAnimation: true,
    );

    if (card.metadata.size > 5000000) {
      // Handle Card Received
      SonrService.completed().then((value) {
        SonrOverlay.back();
      });
    } else {
      // Handle Animation Completed
      Future.delayed(1600.milliseconds, () {
        SonrOverlay.back();
      });
    }
  }

// @ Handle Decline Transfer Response
  _handleDeclineTransfer(AuthInvite invite) {
    if (invite.hasRemote()) {
      SonrService.respond(false, info: invite.remote);
    } else {
      SonrService.respond(false);
    }
    SonrOverlay.back();
  }

// @ Handle Accept Contact Response
  _handleAcceptContact(AuthInvite invite, TransferCard card, bool sendBackContact) {
    // Save Card
    _database.addCard(card);

    // Check if Send Back
    if (sendBackContact) {
      // Check for Remote
      if (invite.hasRemote()) {
        SonrService.respond(true, info: invite.remote);
      } else {
        SonrService.respond(true);
      }
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home/received');
    }
  }

  // @ Helper: Converts Transfer Card Item into TransferCard Protobuf
  static TransferCard _transferCardFromItem(TransferCardItem item) {
    // Set Initial Data
    var card = TransferCard(
      id: item.id,
      payload: item.payload,
      received: item.received.millisecondsSinceEpoch,
      owner: item.owner,
    );

    // Check Payload
    switch (item.payload) {
      case Payload.CONTACT:
        card.contact = item.contact;
        break;
      case Payload.URL:
        card.url = item.url;
        break;
      default:
        card.metadata = item.metadata;
        break;
    }
    return card;
  }
}
