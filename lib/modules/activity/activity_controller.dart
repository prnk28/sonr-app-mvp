import 'package:sonr_app/style.dart';

class ActivityController extends GetxController {
  /// Current List Length
  final activityLength = 0.obs;

  /// Current Page Index
  final currentPageIndex = 0.obs;

  /// Has Session Active
  final hasActiveSession = false.obs;

  /// Past Activities
  final pastActivities = CardService.activity;

  @override
  void onInit() {
    activityLength(CardService.activity.length);
    super.onInit();
  }

  /// Init View for Session
  static void initSession() {
    Get.find<ActivityController>().hasActiveSession(true);
    Get.find<ActivityController>().hasActiveSession.refresh();
  }

  /// Clear All Activity from Table
  Future<void> clearAllActivity() async {
    if (activityLength > 0) {
      var decision = await SonrOverlay.question(
          title: "Clear?", description: "Would you like to clear all activity?", acceptTitle: "Yes", declineTitle: "Cancel");
      if (decision) {
        CardService.clearAllActivity();
      }
    }
  }

  /// Method Sets Current View from Index
  void setView(int index) {
    print(index);
    currentPageIndex(index);
    currentPageIndex.refresh();
  }
}
