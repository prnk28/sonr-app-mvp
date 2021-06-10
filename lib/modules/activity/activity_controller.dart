import 'package:sonr_app/style.dart';

class ActivityController extends GetxController {
  /// Current Activity
  final currentActivity = SonrService.session;

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
  int _hasValidSession() => SonrService.session.isValid ? 1 : 0;
}
