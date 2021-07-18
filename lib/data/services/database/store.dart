import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sonr_app/style/style.dart';

class StoreService extends GetxService {
  /// Reference for Active Users
  final CollectionReference activeUsers = FirebaseFirestore.instance.collection('push-users');

  /// Stream Subscription for Push Token
  late StreamSubscription<String> tokenSubscription;

  /// Stream Subscription for Connectivity
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  /// Initialize PushStore Service
  Future<StoreService> init() async {
    // Handle Token State
    tokenSubscription = ContactService.pushToken.listen(_handlePushToken);
    return this;
  }

  @override
  void onClose() {
    tokenSubscription.cancel();
    connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> addUser(String token) {
    return activeUsers
        .doc(ContactService.sName)
        .set({
          'firstName': ContactService.contact.value.firstName,
          'pushToken': token,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /// Method finds Push Token for User
  Future<String?> findPushToken(String sName) async {
    return activeUsers.doc(sName).get().then((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('pushToken')) {
        return data['pushToken'];
      } else {
        return null;
      }
    });
  }

  /// Helper: Handles Push Token Subscription
  void _handlePushToken(String token) {
    addUser(token);
  }
}
