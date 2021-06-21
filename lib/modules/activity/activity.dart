import 'package:share/share.dart';
import 'package:sonr_app/style.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as pub;

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

  /// Method Exports Transfer based on Payload
  Future<void> exportTransfer(Transfer transfer) async {
    if (transfer.payload.isTransfer) {
      Share.shareFiles(transfer.file.items.map<String>((e) => e.path).toList());
    } else {
      if (transfer.payload.isUrl) {
        Share.share(transfer.url.url, subject: transfer.url.siteName);
      } else if (transfer.payload.isContact) {
        // Request contact permission
        if (await pub.FlutterContacts.requestPermission()) {
          // Insert new contact
          final newContact = pub.Contact()
            ..name.first = 'John'
            ..name.last = 'Smith'
            ..phones = [pub.Phone('555-123-4567')];
          await newContact.insert();
        }
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