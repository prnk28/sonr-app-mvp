part of 'peer.dart';

// ** Proximity Enum ** //
enum ProximityStatus { Immediate, Near, Far, Away }

// ** Modify Graph Values ** //
extension Graphing on Peer {
  // ** Exit Graph from Peer **
  exitGraph(Peer peer) {
    var previousNode = _graph.singleWhere((element) => element.id == peer.id,
        orElse: () => null);

    // Remove Peer Node
    _graph.remove(previousNode);
  }

  // ** Update Graph with new Value **
  updateGraph(Peer peer) {
    // Find Previous Node
    Peer previousNode = _graph.singleWhere((element) => element.id == peer.id,
        orElse: () => null);

    // Remove Peer Node
    _graph.remove(previousNode);

    // Check Node Status: Senders are From
    if (this._canSendTo(peer)) {
      // Calculate Difference and Create Edge
      _graph.setToBy<double>(this, peer, this._getDifference(peer));
    }
  }

  // ** Calculates Costs forEach, Node Placed in Zone **
  getZonedPeers() {
    Map<Peer, double> costs = new Map<Peer, double>();
    List<Peer> activePeers = new List<Peer>();
    // Utilizes Tos
    if (this.status == Status.Searching) {
      // Check then Iterate
      if (!isGraphEmpty()) {
        // Get Receivers
        var receivers = _graph.linkTos(this);

        // Iterate Receivers
        for (Peer receiver in receivers) {
          // Get Cost
          var cost = _graph.getBy<double>(this, receiver);

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
    log.i(activePeers.toString());
    // Return Peers
    return activePeers;
  }

  // ** Checker Method: If Peer can Send to Peer **
  _canSendTo(Peer peer) {
    return this.status == Status.Searching && peer.status == Status.Available;
  }

  // ** Get Difference When User is Searching **
  _getDifference(Peer receiver) {
    // Check Node Status: Senders are From
    if (this.status == Status.Searching &&
        receiver.status == Status.Available) {
      // Calculate Difference
      var diff = this.direction - receiver.direction;

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
