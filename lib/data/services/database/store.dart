import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sonr_app/style/style.dart';

class StoreService extends GetxService {
  /// Stream Subscription for Push Token
  late StreamSubscription<String> tokenSubscription;

  /// Stream Subscription for Connectivity
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  /// Initialize PushStore Service
  Future<StoreService> init() async {
    // Initialize Push Subscription
    await FirebaseFirestore.instance;
    await updateUser(ContactService.pushToken.value);

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

  /// Method finds Push Token for User
  static Future<String?> findPushToken(String sName) async {
    return FirebaseFirestore.instance.collection('push-users').doc(sName).get().then((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('pushToken')) {
        return data['pushToken'];
      } else {
        return null;
      }
    });
  }

  /// Method updates Push Token for User
  static Future<void> updateUser(String token) {
    return FirebaseFirestore.instance
        .collection('push-users')
        .doc(ContactService.sName)
        .set({
          'firstName': ContactService.contact.value.firstName,
          'pushToken': token,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /// Helper: Handles Push Token Subscription
  void _handlePushToken(String token) {
    updateUser(token);
  }
}
