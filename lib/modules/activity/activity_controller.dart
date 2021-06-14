import 'package:sonr_app/service/client/session.dart';
import 'package:sonr_app/style.dart';

class ActivityController extends GetxController {
  /// Has Session Active
  final hasActiveSession = false.obs;

  /// Past Activities
  final pastActivities = CardService.activity;

  /// Current List Length
  final activityLength = 0.obs;

  @override
  void onInit() {
    activityLength(CardService.activity.length + _hasValidSession());
    super.onInit();
  }

  /// Init View for Session
  static void initSession() {
    Get.find<ActivityController>().handleArguments(ActivityArguments(isNewSession: true));
  }

  void setView(int index) {
    print(index);
  }

  void handleArguments(dynamic args) {
    if (args is ActivityArguments) {
      // Update Active Session
      hasActiveSession(args.isNewSession);
    }
  }

  /// Method Helper Returns Active Session Number from Bool
  int _hasValidSession() => SessionService.session.isValid ? 1 : 0;
}
