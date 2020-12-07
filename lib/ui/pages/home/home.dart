import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:sonr_core/sonr_core.dart';

part 'widgets/floater.dart';
part 'widgets/grid.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ** Listen to States ** //
    final ReceiveController receive = Get.find<ReceiveController>();
    receive.addListenerId("Listener", () {
      // Present AuthSheet
      if (receive.status == AuthMessage_Event.REQUEST) {
        Get.bottomSheet(ReceiveSheet());
      }

      // Present Completed Popup
      if (receive.completed) {
        Get.dialog(CompletedPopup());
      }
    });

    // Build View
    return AppTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: titleAppBar("Home"),
        floatingActionButton: FloaterButton((button) {
          // File Option
          if (button == "File") {
            // Push to Transfer Screen
            Get.offNamed("/transfer");
          }
          // Contact Option
          else {
            log.w("Contact not implemented yet");
          }
        }),
        body: ImageGrid()));
  }
}
