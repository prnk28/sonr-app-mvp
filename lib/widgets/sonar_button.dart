
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/model/match_transaction.dart';

class SonarButton extends StatelessWidget {
  // Parameters
  final Map<String, dynamic> userData;
  final ValueChanged<Map> onSend;
  SonarButton({Key key, this.userData, this.onSend}) : super(key: key);

  // Initialization
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        onSend(userData);
        _pushAndMatchData(context);
      },
      child: const Icon(Icons.publish),
    );
  }

  // Match Method
  _pushAndMatchData(BuildContext context) async {
    // Get Location
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var request = MatchTransaction(userData, position);

      // Push to Firestore
      Firestore.instance
          .collection('active-transactions')
          .document(request.documentID)
          .setData(request.createTransaction());

      // Attempt Match
      try {
        final dynamic resp = await CloudFunctions.instance.call(
          functionName: 'matchRequest',
          parameters: <String, dynamic>{
            'transactionID': request.transactionID,
            'documentID': request.documentID
          },
        );
        print(resp["data"]);
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(resp["data"])));
        // Cloud Fail
      } on CloudFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e.code);
        print(e.message);
        print(e.details);
      } catch (e) {
        print('caught generic exception');
        print(e);
      }
    } else {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationWhenInUse]);
    }
  }
}