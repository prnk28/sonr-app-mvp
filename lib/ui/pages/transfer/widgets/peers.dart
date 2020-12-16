import '../../../ui.dart';
import 'package:flutter/widgets.dart';
import 'bubble.dart';

// ^ Widget that Builds Stack of Peers ^ //
class PeerStack extends GetView<LobbyController> {
  @override
  Widget build(BuildContext context) {
    // @ Bubble View
    return Obx(() {
      // Initialize Widget List
      List<Bubble> stackWidgets = new List<Bubble>();

      // @ Verify Not Null
      if (controller.size > 0) {
        // Init Stack Vars
        int total = controller.size() + STACK_CONSTANT;
        double mean = 1.0 / total;
        int current = 0;

        // @ Create Bubbles that arent added
        controller.peers().forEach((peer) {
          // Create Bubble
          stackWidgets.add(Bubble(current * mean, peer));
          current++;
        });
      }
      return Stack(children: stackWidgets);
    });
  }
}
