// 1. Get all Tos/Froms in Graph based on user peer status
// 2. Create List<Peer, double> where double is edge value
// 3. Iterate through Tos/froms and use getBy<double> to assign edge value
// 4. Iterate through Map<Peer, double> by double value once and compare current node edge value to current lowest node edge value
// 5. Set closestNeighbor as node with lowest value at end of iteration

import 'package:graph_collection/graph.dart';
import 'package:sonar_app/models/models.dart';

import 'core.dart';

class PathFinder {
  // Reference Variables
  DirectedValueGraph _graph;
  Map<Peer, double> _costs;
  bool isEmpty;

  // Public Lists by Proximity
  Map<Peer, double> immediate;
  Map<Peer, double> near;
  Map<Peer, double> far;
  Map<Peer, double> distant;

  // ** Constructer: Calculates Costs for Each Node **
  PathFinder(this._graph, Peer userNode) {
    // Initialize Costs Map
    _costs = new Map<Peer, double>();

    // Initialize Proximity Maps
    immediate = new Map<Peer, double>();
    near = new Map<Peer, double>();
    far = new Map<Peer, double>();
    distant = new Map<Peer, double>();

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

        // Assign
        _assignToList(sender, cost.val);
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

        // Assign
        _assignToList(receiver, cost.val);
      }
    }
  }

  // Method to Assign Peer to List
  void _assignToList(Peer peer, double cost) {
    // Immediate
    if (cost < 60) {
      immediate[peer] = peer.direction;
    }
    // Near
    else if (cost >= 60 && cost < 120) {
      near[peer] = peer.direction;
    }
    // Far
    else if (cost >= 120 && cost < 180) {
      far[peer] = peer.direction;
    }
    // Distant
    else {
      distant[peer] = peer.direction;
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
