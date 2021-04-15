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
  final _allCards = RxList<TransferCardItem>();
  final _contactCards = RxList<TransferCardItem>();
  final _fileCards = RxList<TransferCardItem>();
  final _mediaCards = RxList<TransferCardItem>();
  final _urlCards = RxList<TransferCardItem>();

  // Property Accessors
  static RxList<TransferCardItem> get allCards => to._allCards;
  static RxList<TransferCardItem> get contactCards => to._contactCards;
  static RxList<TransferCardItem> get fileCards => to._fileCards;
  static RxList<TransferCardItem> get mediaCards => to._mediaCards;
  static RxList<TransferCardItem> get urlCards => to._urlCards;

  // Utility
  static bool get hasContacts => to._contactCards.length > 0;
  static bool get hasFiles => to._fileCards.length > 0;
  static bool get hasMedia => to._mediaCards.length > 0;
  static bool get hasURLs => to._urlCards.length > 0;

  // References
  final _database = CardsDatabase();

  // * Constructer * //
  Future<CardService> init() async {
    _allCards.bindStream(_database.watchAll());
    _contactCards.bindStream(_database.watchContacts());
    _fileCards.bindStream(_database.watchFiles());
    _mediaCards.bindStream(_database.watchMedia());
    _urlCards.bindStream(_database.watchUrls());
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

  // ^ Add New Card to Database ^ //
  static deleteCard(TransferCardItem card) async {
    await to._database.deleteCard(card);
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
}
