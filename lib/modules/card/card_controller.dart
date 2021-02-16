import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/progress_view.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/service/timer_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

export 'contact_view.dart';
export 'file_view.dart';
export 'media_view.dart';
export 'url_view.dart';
export 'progress_view.dart';

enum CardType { None, Invite, Reply, GridItem }

class TransferCardController extends GetxController {
  // Properties
  final state = CardType.None.obs;
  RxDouble progress = 0.0.obs;
  TransferCard card;
  int index;

  // References
  bool _accepted = false;
  final _kMinimumDuration = 250.milliseconds;
  final _kAnimationDuration = 1750.milliseconds;
  bool _isUsingTimer = false;

  // ^ Handle Transfer Progress ^
  TransferCardController() {
    // @ Start Timer
    Get.find<TimerService>().start(intervals: [_kMinimumDuration], stopTime: _kAnimationDuration);

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

  // ^ Accept File Invite Request ^ //
  acceptFile(IconData iconData) {
    Get.back();
    Get.dialog(
      ProgressView(this, iconData),
      useRootNavigator: false,
      useSafeArea: false,
      barrierDismissible: false,
      transitionDuration: 100.milliseconds,
    );
    Get.find<SonrService>().respond(true);
    _accepted = true;
  }

  // ^ Accept Contact Invite Request ^ //
  acceptContact(TransferCard c, bool sb) {
    // Check if Send Back
    if (sb) {
      Get.find<SonrService>().respond(true);
    }

    // Save Card
    Get.find<SQLService>().storeCard(c);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(c);
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    if (!_accepted) {
      Get.find<SonrService>().respond(false);
    }

    Get.back();
    state(CardType.None);
  }
}
