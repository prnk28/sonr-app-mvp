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
    return GetBuilder(builder: (_) {
      // @ Verify Not Null
      if (controller.size > 0) {
        // Init Stack Vars
        int total = controller.peers.length + STACK_CONSTANT;
        double mean = 1.0 / total;
        int current = 0;

        // @ Create Bubbles that arent added
        controller.peers.forEach((id, peer) {
          // Check if Bubble Already Added
          if (!stackWidgets.containsKey(id)) {
            // Increase Count
            current += 1;
            // Create Bubble
            stackWidgets[id] = Bubble(current * mean, peer);
          }
        });

        // @ Remove Bubbles that no longer exist
        stackWidgets.forEach((id, bubble) {
          if (!controller.peers.containsKey(id)) {
            stackWidgets.remove(id);
          }
        });
      }
      return Stack(children: stackWidgets.values.toList());
    });
  }
}