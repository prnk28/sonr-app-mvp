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
        body: _HomeView()));
  }
}

class _HomeView extends StatelessWidget {
  final SonrController sonrController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (sonrController.status() == SonrStatus.Pending) {
      Get.dialog(AuthSheet(message: sonrController.auth.value));
    } else if (sonrController.status() == SonrStatus.Receiving) {
      Get.dialog(ProgressSheet());
    }

    return ImageGrid();
  }
}
