import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/common/lobby/local_view.dart';
import 'package:sonr_app/common/lobby/remote_view.dart';
import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<TransferController>(
      init: TransferController(),
      builder: (controller) {
        if (controller.isRemoteActive.value) {
          return RemoteLobbyFullView(controller, info: controller.remote.value);
        } else {
          return LocalLobbyView(controller);
        }
      },
    );
  }
}
