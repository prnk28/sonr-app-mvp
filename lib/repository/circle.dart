import 'package:graph_collection/graph.dart';
import 'package:sonar_app/models/models.dart';

// ** Modify Graph Values ** //
class Circle {
  DirectedValueGraph _graph;

  Circle() {
    _graph = new DirectedValueGraph();
  }

  // ** Exit Graph from Peer **
  exitGraph(Node peer) {
    var previousNode = _graph.singleWhere((element) => element.id == peer.id,
        orElse: () => null);

    // Remove Peer Node
    _graph.remove(previousNode);
  }

  // ** Update Graph with new Value **
  updateGraph(Node sender, Node receiver) {
    // Find Previous Node
    Node previousNode = _graph.singleWhere(
        (element) => element.id == receiver.id,
        orElse: () => null);

    // Remove Peer Node
    _graph.remove(previousNode);

    // Check Node Status: Senders are From
    if (sender.canSendTo(receiver)) {
      // Calculate Difference and Create Edge
      _graph.setToBy<double>(
          sender, receiver, this._getDifference(sender, receiver));
    }
  }

  // ** Calculates Costs forEach, Node Placed in Zone **
  List<Node> getZonedPeers(Node user) {
    Map<Node, double> costs = new Map<Node, double>();
    List<Node> activePeers = new List<Node>();
    // Utilizes Tos
    if (user.status == Status.Searching) {
      // Check then Iterate
      if (!isGraphEmpty()) {
        // Get Receivers
        var receivers = _graph.linkTos(this);

        // Iterate Receivers
        for (Node receiver in receivers) {
          // Get Cost
          var cost = _graph.getBy<double>(this, receiver);

          // Place in Map
          costs[receiver] = cost.val as double;

          // ** Assign active to list **
          // Check if off Screen
          if (cost.val > 180 && cost.val != -1) {
            // Set as off screen
            receiver.proximity = Proximity.Away;
          } else {
            // TODO: Assign by UltraSonic Proximity
            receiver.proximity = Proximity.Near;
            activePeers.add(receiver);
          }
        }
      }
    }
    // Return Peers
    return activePeers;
  }

  // ** Get Difference When User is Searching **
  _getDifference(Node sender, Node receiver) {
    // Check Node Status: Senders are From
    if (sender.status == Status.Searching &&
        receiver.status == Status.Available) {
      // Calculate Difference
      var diff = sender.direction - receiver.direction;

      // Log and Get difference
      return diff.abs();
    }
    return -1;
  }

  // ** Checker for if Graph Empty **
  isGraphEmpty() {
    // Get Receivers
    var receivers = _graph.linkTos(this);

    // Set isEmpty
    if (receivers.length > 0) {
      return false;
    } else {
      return true;
    }
  }
}
