import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/progress_view.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/service/timer_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/widgets/overlay.dart';
import 'package:sonr_core/sonr_core.dart';

export 'contact_view.dart';
export 'file_view.dart';
export 'media_view.dart';
export 'url_view.dart';
export 'progress_view.dart';

enum CardType { None, Invite, Reply, GridItem, Info }

class TransferCardController extends GetxController {
  // Properties
  final state = CardType.None.obs;
  RxDouble progress = 0.0.obs;
  TransferCard card;
  int index;

  // References
  bool _isUsingTimer = false;
  final _kMinimumDuration = 250.milliseconds;
  final _kAnimationDuration = 1750.milliseconds;

  // ^ Handle Transfer Progress ^
  TransferCardController() {
    // @ Listen for Minimum Timer
    Get.find<TimerService>().timerIntervals.listen((data) {
      data.forEach((time, status) {
        // Check if Transfer Completed Before Animation
        if (time == _kMinimumDuration && status && Get.find<SonrService>().progress.round() == 1) {
          _isUsingTimer = true;
          progress = Get.find<TimerService>().progress;
        }
        // Set Progress for Transfer
        else {
          _isUsingTimer = false;
          progress = Get.find<SonrService>().progress;
        }
      });
    });

    // @ Listen for Timer Complete
    Get.find<TimerService>().elapsed.listen((value) {
      if (_isUsingTimer) {
        if (value == _kAnimationDuration) {
          Get.back();
        }
      }
    });

    // @ Listen for Transfer Complete
    Get.find<SonrService>().progress.listen((value) {
      if (!_isUsingTimer) {
        if (value == 1.0) {
          Get.back();
        }
      }
    });
  }

  // ^ Sets TransferCard Data for this Widget ^
  initialize(TransferCard card, int index) {
    this.card = card;
    this.index = index;
  }

  // ^ Sets Card for Invited Data for this Widget ^
  invited() {
    state(CardType.Invite);
  }

  // ^ Accept Contact Invite Request ^ //
  acceptTransfer(TransferCard card, {bool sendBackContact = false}) {
    // Check Card Type
    if (card.payload == Payload.CONTACT) {
      // Check if Send Back
      if (sendBackContact) {
        Get.find<SonrService>().respond(true);
      }

      // Save Card
      Get.find<SQLService>().storeCard(card);
      Get.find<HomeController>().addCard(card);
    } else {
      Get.find<SonrService>().respond(true);
      Get.find<TimerService>().start(intervals: [_kMinimumDuration], stopTime: _kAnimationDuration);
      Get.back();
      Get.dialog(
        ProgressView(this, SonrIcon.preview(IconType.Thumbnail, card).data),
        useRootNavigator: false,
        useSafeArea: false,
        barrierDismissible: false,
        transitionDuration: 100.milliseconds,
      );
    }
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    Get.find<SonrService>().respond(false);
    Get.back();
    state(CardType.None);
  }

  // ^ Method to Present Card Overlay Info
  showCardInfo(BuildContext context, Widget infoWidget) {
    SonrOverlay(overlayWidget: infoWidget, context: context);
  }
}
