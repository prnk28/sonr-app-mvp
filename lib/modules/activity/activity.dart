import 'package:sonr_app/style.dart';
export 'activity.dart';
export 'widgets/current_item.dart';
export 'widgets/past_item.dart';
export 'views/activity_view.dart';
export 'models/arguments.dart';
export 'models/type.dart';

class ActivityController extends GetxController {
  /// Current Page Index
  final currentPageIndex = 0.obs;

  /// Past Activities
  final pastActivities = CardService.activity;

  /// Action Button Key
  final clearButtonKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
  }

  /// Clear All Activity from Table
  Future<void> clearAllActivity() async {
    if (CardService.activity.length > 0) {
      var decision =
          await AppRoute.question(title: "Clear?", description: "Would you like to clear all activity?", acceptTitle: "Yes", declineTitle: "Cancel");
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
