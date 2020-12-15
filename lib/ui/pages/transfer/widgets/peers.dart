import '../../../ui.dart';
import 'package:flutter/widgets.dart';
import 'bubble.dart';

// ^ Widget that Builds Stack of Peers ^ //
class PeerStack extends GetView<LobbyController> {
  @override
  Widget build(BuildContext context) {
    // Initialize Widget List
    Map<String, Bubble> stackWidgets = new Map<String, Bubble>();

    // @ Bubble View
    return Obx(() {
      // @ Verify Not Null
      if (controller.size > 0) {
        // Init Stack Vars
        int total = controller.peers().length + STACK_CONSTANT;
        double mean = 1.0 / total;

        // @ Create Bubbles that arent added
        controller.peers().forEach((id, peer) {
          // Check if Bubble Already Added
          if (!stackWidgets.containsKey(id)) {
            // Create Bubble
            var idx = controller.peers().values.toList().indexOf(peer);
            stackWidgets[id] = Bubble(idx * mean, peer);
          }
        });

        // @ Remove Bubbles that no longer exist
        stackWidgets.forEach((id, bubble) {
          if (!controller.peers().containsKey(id)) {
            stackWidgets.remove(id);
          }
        });
      }
      return Stack(children: stackWidgets.values.toList());
    });
  }
}
