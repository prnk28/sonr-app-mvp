import 'package:sonr_app/service/client/session.dart';
import 'package:sonr_app/style.dart';

class ActivityController extends GetxController {
  /// Current Activity
  final currentActivity = SessionService.session;

  /// Past Activities
  final pastActivities = CardService.activity;

  /// Current List Length
  final activityLength = 0.obs;

  @override
  void onInit() {
    activityLength(CardService.activity.length + _hasValidSession());
    super.onInit();
  }

  /// Method Helper Returns Active Session Number from Bool
  int _hasValidSession() => SessionService.session.isValid ? 1 : 0;
}
