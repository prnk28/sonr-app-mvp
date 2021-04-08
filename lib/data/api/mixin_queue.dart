import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/common/peer/peer_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;

class TransferQueue {
  // Properties
  List<TransferQueueItem> transferQueue = <TransferQueueItem>[];
  Payload get payload => transferQueue.length > 0 ? transferQueue.last.payload : null;
  TransferQueueItem get currentTransfer => transferQueue.length > 0 ? transferQueue.last : null;
  bool get isQueueEmpty => transferQueue.length == 0;
  bool get isQueueNotEmpty => transferQueue.length > 0;
  int get queueSize => transferQueue.length;

  // References
  var _received = new Completer<TransferCard>();
  Completer<TransferCard> get received => _received;

  // ^ Add to Queue With TransferQueueItem^ //
  int addToQueue(TransferQueueItem item) {
    transferQueue.add(item);
    return transferQueue.length - 1;
  }

  // ^ Complete Current/Last Transfer ^ //
  Future<bool> currentCompleted() async {
    var item = currentTransfer;
    if (item != null) {
      await item.complete();
      transferQueue.removeLast();
      return true;
    }
    return false;
  }

  // ^ Current Peer has Decided ^ //
  currentDecided(bool decision) async {
    if (isQueueNotEmpty) {
      TransferQueueItem item = currentTransfer;
      await item.setDecision(decision);
      if (!decision) {
        transferQueue.removeLast();
      }
    }
  }

  // ^ Current Transfer has Updated Progress ^ //
  currentInvited(PeerController controller) {
    if (isQueueNotEmpty) {
      currentTransfer.peerController = controller;
    }
  }

  // ^ Current Transfer has Updated Progress ^ //
  currentInvitedFromList(Peer peer) {
    if (isQueueNotEmpty) {
      currentTransfer.peer = peer;
    }
  }

  // ^ Current Transfer has Updated Progress ^ //
  currentProgressed(double progress) {
    if (isQueueNotEmpty) {
      currentTransfer.progress(progress);
    }
  }

  // ^ Complete Current/Last Transfer ^ //
  Metadata lastMedia({bool status = true}) {
    if (transferQueue.length > 0) {
      var item = transferQueue.firstWhere((element) => element.payload == Payload.MEDIA, orElse: () => null);
      if (item != null) {
        return item.data is Metadata ? item.data : null;
      }
    }
    return null;
  }

  // ^ Complete Transfer At Index ^ //
  String lastUrl(int i, {bool status = true}) {
    if (transferQueue.length > 0) {
      var item = transferQueue.firstWhere((element) => element.payload == Payload.MEDIA, orElse: () => null);
      if (item != null) {
        return item.data is String ? item.data : null;
      }
    }
    return null;
  }

  // ^ Clear All Queue^ //
  bool resetQueue() {
    if (transferQueue.length > 0) {
      transferQueue.clear();
      _received = new Completer<TransferCard>();
      return true;
    }
    return false;
  }
}

class TransferQueueItem {
  // Properties
  final bool isFlat;
  final bool isMultiple;
  final progress = 0.0.obs;
  final Payload payload;
  final String url;
  final Metadata media;
  final List<Metadata> files;

  // Controller
  PeerController _peerController;
  bool get hasPeerController => _peerController != null;
  PeerController get peerController => hasPeerController ? _peerController : null;
  set peerController(PeerController controller) => _peerController = controller;

  // Controller
  Peer _peer;
  bool get hasPeer => _peer != null;
  Peer get peer => hasPeer ? _peer : null;
  set peer(Peer peer) => _peer = peer;

  // Get Data
  dynamic get data {
    switch (payload) {
      case Payload.CONTACT:
        return "Payload is Contact";
        break;
      case Payload.MEDIA:
        if (isMultiple) {
          return files;
        } else {
          return media;
        }
        break;
      case Payload.URL:
        return url;
        break;
    }
  }

  factory TransferQueueItem.contact({bool isFlat = false}) {
    return TransferQueueItem(Payload.CONTACT, isFlat: isFlat);
  }

  factory TransferQueueItem.media(Metadata info) {
    return TransferQueueItem(Payload.MEDIA, media: info);
  }

  factory TransferQueueItem.capture(MediaFile media) {
    var file = Metadata(
      path: media.path,
      thumbnail: media.thumbnail,
      properties: Metadata_Properties(
        duration: media.duration,
        isVideo: media.isVideo,
      ),
    );
    return TransferQueueItem(Payload.MEDIA, media: file);
  }

  factory TransferQueueItem.files(List<Metadata> files) {
    return TransferQueueItem(Payload.MEDIA, files: files, isMultiple: true);
  }

  factory TransferQueueItem.url(String url) {
    return TransferQueueItem(Payload.URL, url: url);
  }

  // * Constructer * //
  TransferQueueItem(this.payload, {this.url, this.media, this.files, this.isMultiple = false, this.isFlat = false});

  // ^ Peer Decided on Invite ^ //
  Future<bool> setDecision(bool decision) async {
    // Completer for Played
    var played = new Completer<bool>();

    if (hasPeer) {
      HapticFeedback.mediumImpact();
      played.complete(true);
    } else {
      // Validate Controller
      if (hasPeerController) {
        // Play Feedback
        HapticFeedback.mediumImpact();

        // Check Decision
        if (decision) {
          peerController.playAccepted();
          played.complete(true);
        } else {
          _peerController.playDenied();
          played.complete(true);
        }
      } else {
        played.complete(false);
      }
    }

    return played.future;
  }

  // ^ Function to Set Completed Value ^ //
  Future<bool> complete() async {
    // Completer for Played
    var played = new Completer<bool>();
    HapticFeedback.heavyImpact();
    if (hasPeerController) {
      _peerController.playCompleted();
    }
    return played.future;
  }
}
