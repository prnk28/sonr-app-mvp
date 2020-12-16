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

class HomeScreen extends GetView<ReceiveController> {
  @override
  Widget build(BuildContext context) {
    // ** Listen to States ** //
    controller.addListenerId("Listener", () {
      if (controller.status == Status.Pending) {
        Get.bottomSheet(InviteSheet());
      } else if (controller.status == Status.Complete) {
        Get.dialog(CompletedPopup());
        controller.finish();
      }
    });

    // Build View
    return AppTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: titleAppBar("Home"),
        floatingActionButton: FloaterButton(() {
          // File Option
          Get.offNamed("/transfer");
        }),
        body: ImageGrid()));
  }
}
