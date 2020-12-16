import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ PeerStatus Enum ^ //
enum ProfileStatus {
  Idle,
  Invited,
  Accepted,
  Denied,
  Completed,
}

class PeerController extends GetxController {
  final Contact user;

  PeerController(this.user);

  updateCoreValue() {

  }
}
