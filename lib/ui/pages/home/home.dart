import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:sonr_core/sonr_core.dart';

part 'widgets/card.dart';
part 'widgets/floater.dart';
part 'widgets/grid.dart';

Logger log = Logger();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ** Listen to States ** //
    final ReceiveController sonr = Get.find<ReceiveController>();
    sonr.addListenerId("Listener", () {
      print("State is Pending");
      Get.dialog(AuthSheet());
    });

    // TODO: Implement Transform on Auth Sheet
    // sonr.addListenerId("Receiving", () {
    //   if (sonr.status == SonrStatus.Receiving) {
    //     print("State is Receiving");
    //     Get.dialog(ProgressSheet());
    //   }
    // });

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
