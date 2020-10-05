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
  Graph _graph;
  Map<Peer, double> costs;

  // Class Variables
  Peer get closestNeighbor {
    // Initial Closest Peer
    Peer currentClosestPeer;

    // Initial lowest cost with arbitray high value
    double currentLowestCost = 10000;

    // Iterate
    costs.forEach((peer, cost) {
      // Check Cost
      if (cost < currentLowestCost) {
        // Update Cost, Closest Neighbor
        currentLowestCost = cost;
        currentClosestPeer = currentClosestPeer;
      }
    });

    // Return Peer
    return currentClosestPeer;
  }

  // ** Constructer: Calculates Costs for Each Node **
  PathFinder(this._graph, Peer userNode) {
    // Initialize Costs Map
    costs = new Map<Peer, double>();

    // Utilizes Froms
    if (userNode.status == PeerStatus.Receiving) {
      // Get Senders
      var senders = _graph.linkFroms(userNode);

      // Iterate
      for (Peer sender in senders) {
        // Get Cost
        var cost = _graph.getBy<double>(sender, userNode);

        // Place in Map
        cost.some((val) => () {
              log.i("Cost: " + val.toString());
              costs[sender] = cost as double;
            });
      }
    }
    // Utilizes Tos
    else if (userNode.status == PeerStatus.Sending) {
      // Get Receivers
      var receivers = _graph.linkTos(userNode);

      // Iterate
      for (Peer receiver in receivers) {
        // Get Cost
        var cost = _graph.getBy<double>(userNode, receiver);

        // Place in Map
        cost.some((val) => () {
              log.i("Cost: " + val.toString());
              costs[receiver] = cost as double;
            });
      }
    }
    // Error
    else {
      log.e("Invalid Peer Status during PathFinding");
    }
  }
}
