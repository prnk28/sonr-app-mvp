// 1. Get all Tos/Froms in Graph based on user peer status
// 2. Create List<Peer, double> where double is edge value
// 3. Iterate through Tos/froms and use getBy<double> to assign edge value
// 4. Iterate through Map<Peer, double> by double value once and compare current node edge value to current lowest node edge value
// 5. Set closestNeighbor as node with lowest value at end of iteration
part of 'core.dart';

class PathFinder {
  // Reference Variables
  DirectedValueGraph _graph;
  Map<Peer, double> _costs;
  bool isEmpty;

  // Public Lists by Proximity
  List<Peer> activePeers;

  // ** Constructer: Calculates Costs for Each Node **
  PathFinder(this._graph, Peer userNode) {
    // Initialize Costs Map
    _costs = new Map<Peer, double>();

    // Initialize Proximity Maps
    activePeers = new List<Peer>();

    // Utilizes Froms
    if (userNode.status == PeerStatus.Active) {
      // Get Senders
      var senders = _graph.linkFroms(userNode);

      // Set isEmpty
      if (senders.length > 0) {
        isEmpty = false;
      } else {
        isEmpty = true;
      }

      // Iterate
      for (Peer sender in senders) {
        // Get Cost
        var cost = _graph.getBy<double>(sender, userNode);

        // Place in Map
        _costs[sender] = cost.val as double;
      }
    }
    // Utilizes Tos
    else if (userNode.status == PeerStatus.Searching) {
      // Get Receivers
      var receivers = _graph.linkTos(userNode);

      // Set isEmpty
      if (receivers.length > 0) {
        isEmpty = false;
      } else {
        isEmpty = true;
      }

      // Iterate
      for (Peer receiver in receivers) {
        // Get Cost
        var cost = _graph.getBy<double>(userNode, receiver);

        // Place in Map
        _costs[receiver] = cost.val as double;

        // Assign active to list
        _assignActivePeer(receiver, cost.val);
      }
    }
  }

  // Method to Assign Peer to List
  void _assignActivePeer(Peer peer, double difference, {double proximity}) {
    // Check if off Screen
    if (difference > 180 && difference != -1) {
      // Set as off screen
      peer.proximity = ProximityStatus.Away;
    } else {
      // TODO: Assign by UltraSonic Proximity
      // Update Proximity to Temp Value
      peer.proximity = ProximityStatus.Near;
      activePeers.add(peer);
    }
  }

  // Method to Get Closest Peer
  Peer getClosestNeighbor() {
    // Initial Closest Peer
    Peer currentClosestPeer;

    // Initial lowest cost with arbitray high value
    double currentLowestCost = 10000;

    // Iterate
    _costs.forEach((peer, cost) {
      // Check Cost
      if (cost < currentLowestCost) {
        // Update Cost, Closest Neighbor
        currentLowestCost = cost;
        currentClosestPeer = peer;
      }
    });

    // Return Peer
    return currentClosestPeer;
  }
}
