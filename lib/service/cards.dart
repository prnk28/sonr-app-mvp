import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/theme/theme.dart';

class CardsService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<CardsService>();
  static CardsService get to => Get.find<CardsService>();

  // Properties
  final allCards = RxList<TransferCardItem>();
  final contactCards = RxList<TransferCardItem>();
  final mediaCards = RxList<TransferCardItem>();
  final urlCards = RxList<TransferCardItem>();

  // References
  final _database = CardsDatabase();

  // * Constructer * //
  Future<CardsService> init() async {
    allCards.bindStream(_database.watchAll());
    contactCards.bindStream(_database.watchContacts());
    mediaCards.bindStream(_database.watchMedia());
    urlCards.bindStream(_database.watchUrls());
    return this;
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
        Get.offNamed('/home/received');
      });
    } else {
      // Handle Animation Completed
      Future.delayed(1600.milliseconds, () {
        SonrOverlay.back();
        Get.offNamed('/home/received');
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
