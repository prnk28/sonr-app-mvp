import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:sonar_frontend/main.dart';
import 'package:sonar_frontend/model/match_transaction.dart';

class ServerUtility {

  static callTransferRecycle(String docID) async {
    // Init Parameters
    var params= {"id" : docID};

    // Call Request
      await CloudFunctions.instance.call(
          functionName: 'recycleTransferRequest',
          parameters: params
        );
  }

  static confirmAuthorization(doc, userPosition) {
    // Update Doc by User Position
    if (userPosition == 1) {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .get()
          .then((snap) {
        if (snap.data["secondUserConfirmed"] == true) {
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'firstUserConfirmed': true,
            'status': 100
          });
        } else{
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'firstUserConfirmed': true
          });
        }
      });
    } else {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .get()
          .then((snap) {
        if (snap.data["firstUserConfirmed"] == true) {
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'secondUserConfirmed': true,
            'status': 100
          });
        } else{
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'secondUserConfirmed': true
          });
        }
      });
    }
    // Reset userPosition
    userPosition = 0;
  }

  static cancelAuthorization(doc, userPosition) {
    // Update Doc by User Position
    if (userPosition == 1) {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .updateData({'firstUserConfirmed': false, 'status': 000});
    } else {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .updateData({'secondUserConfirmed': false, 'status': 000});
    }
    // Reset userPosition
    userPosition = 0;
  }
}
