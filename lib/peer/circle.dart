part of 'peer.dart';

enum ProximityStatus { Immediate, Near, Far, Away }

extension Circle on Peer {
  // ** Exit Graph from Peer **
  void exitGraph(Peer peer) {
    var previousNode = graph.singleWhere(
        (element) => element.session_id == peer.id,
        orElse: () => null);

    // Remove Peer Node
    graph.remove(previousNode);
  }

  // ** Update Graph with new Value **
  void updateGraph(Peer peer) {
    // Check Node Status: Senders are From
    if (this.canSendTo(peer)) {
      // Find Previous Node
      Peer previousNode = graph.singleWhere(
          (element) => element.session_id == peer.id,
          orElse: () => null);

      // Remove Peer Node
      graph.remove(previousNode);

      // Calculate Difference and Create Edge
      graph.setToBy<double>(this, peer, this.getDifference(peer));
    }
  }

  // ** Calculates Costs forEach, Node Placed in Zone **
  List<Peer> getZonedPeers() {
    Map<Peer, double> costs = new Map<Peer, double>();
    // Utilizes Tos
    if (this.status == Status.Searching) {
      // Check then Iterate
      if (!isGraphEmpty()) {
        // Get Receivers
        var receivers = graph.linkTos(this);

        // Iterate Receivers
        for (Peer receiver in receivers) {
          // Get Cost
          var cost = graph.getBy<double>(this, receiver);

          // Place in Map
          costs[receiver] = cost.val as double;

          // ** Assign active to list **
          // Check if off Screen
          if (cost.val > 180 && cost.val != -1) {
            // Set as off screen
            receiver.proximity = ProximityStatus.Away;
          } else {
            // TODO: Assign by UltraSonic Proximity
            receiver.proximity = ProximityStatus.Near;
            activePeers.add(receiver);
          }
        }
      }
    }
    // Return Peers
    return activePeers;
  }

  // ** Checker for if Graph Empty **
  bool isGraphEmpty() {
    // Get Receivers
    var receivers = graph.linkTos(this);

    // Set isEmpty
    if (receivers.length > 0) {
      return false;
    } else {
      return true;
    }
  }
}
