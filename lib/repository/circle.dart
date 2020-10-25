import 'package:graph_collection/graph.dart';
import 'package:sonar_app/models/models.dart';
import 'package:vector_math/vector_math.dart';

// ** Proximity Enum ** //
enum Proximity { Immediate, Near, Far, Away }

// ** Modify Graph Values ** //
class Circle {
  DirectedValueGraph graph;

  Circle() {
    graph = new DirectedValueGraph();
  }

  // ** Exit Graph from Peer **
  exitGraph(String peer) {
    var previousNode =
        graph.singleWhere((element) => element.id == peer, orElse: () => null);

    // Remove Peer Node
    graph.remove(previousNode);
  }

  // ** Update Graph with new Value **
  updateGraph(Node sender, Node receiver) {
    // Find Previous Node
    var previousNode = graph.singleWhere((element) => element.id == receiver.id,
        orElse: () => null);

    // Remove Peer Node
    graph.remove(previousNode);

    // Check Node Status: Senders are From
    if (_canSendTo(sender, receiver)) {
      // Calculate Difference and Create Edge
      graph.setToBy<double>(sender, receiver, _getDifference(sender, receiver));
    }
  }

  // ** Calculates Costs forEach, Node Placed in Zone **
  List<Node> getZonedPeers(Node user) {
    Map<Node, double> costs = new Map<Node, double>();
    List<Node> activePeers = new List<Node>();
    // Utilizes Tos
    if (user.status == Status.Searching) {
      // Check then Iterate
      if (!isGraphEmpty(user)) {
        // Get Receivers
        var receivers = graph.linkTos(user);

        // Iterate Receivers
        for (Node receiver in receivers) {
          // Get Cost
          var cost = graph.getBy<double>(user, receiver);

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

  // ** Checker Method: If Peer can Send to Peer **
  _canSendTo(Node sender, Node receiver) {
    // Verify Status
    bool statusCheck;
    statusCheck = sender.status == Status.Searching &&
        receiver.status == Status.Available;

    // Check Id
    bool idCheck;
    idCheck = sender.id != null && receiver.id != null;

    // Validate
    return statusCheck && idCheck;
  }

  // ** Get Difference When User is Searching **
  _getDifference(Node sender, Node receiver) {
    // Get Receiver Antipodal Degrees
    double receiverAntipodal = _getAntipodal(receiver.direction);

    // Difference between angles
    double theta;
    if (receiverAntipodal > sender.direction) {
      theta = receiverAntipodal - sender.direction;
    } else {
      theta = sender.direction - receiverAntipodal;
    }

    // Log and Get difference
    return radians(theta);
  }

  _getAntipodal(double degrees) {
    if (degrees > 180) {
      return degrees - 180;
    } else {
      return degrees + 180;
    }
  }

  // ** Checker for if Graph Empty **
  isGraphEmpty(Node user) {
    // Get Receivers
    var receivers = graph.linkTos(user);

    // Set isEmpty
    if (receivers.length > 0) {
      return false;
    } else {
      return true;
    }
  }
}
