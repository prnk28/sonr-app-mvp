import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/card/progress_view.dart';
import 'package:sonr_core/sonr_core.dart';

export 'contact_view.dart';
export 'file_view.dart';
export 'media_view.dart';
export 'url_view.dart';
export 'progress_view.dart';

enum CardType { None, Invite, InviteFlat, Reply, GridItem, Info }

class TransferCardController extends GetxController {
  // Properties
  final animationCompleted = false.obs;

  // ^ Accept Transfer Invite Request ^ //
  promptSendBack(AuthInvite invite, TransferCard card) async {
    var result = await SonrOverlay.question(title: "Send Back", description: "Would you like to send your contact back?");
    CardService.handleInviteResponse(true, invite, card, sendBackContact: result);
  }

  // ^ Method to Present Card Overlay Info
  showCardInfo(Widget infoWidget) {
    SonrOverlay.show(infoWidget, disableAnimation: true, barrierDismissible: true);
  }
}
