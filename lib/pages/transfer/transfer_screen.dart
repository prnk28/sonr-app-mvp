import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/common/lobby/local_view.dart';
import 'package:sonr_app/modules/common/lobby/remote_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isRemoteActive.value) {
          return RemoteLobbyFullView(controller, info: controller.remote.value);
        } else {
          return LocalLobbyView();
        }
      },
    );
  }
}
