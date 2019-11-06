import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_frontend/websockets/client_ws.dart';

class SonarBox extends StatefulWidget {
  String title, description, buttonText;
  final Map<String, dynamic> requestData, userData;
  final Image image;

  SonarBox(
      {Key key,
      this.title,
      this.description,
      this.buttonText,
      this.image,
      this.requestData,
      this.userData})
      : super(key: key);
  _SonarBoxState createState() => _SonarBoxState();
}

class _SonarBoxState extends State<SonarBox> {
  // Variables
  String playerName;
  List<dynamic> playersList = <dynamic>[];
   // Storage Parameters


  // Initialize
  @override
  void initState() {
    sonar.addListener(_onSonarDataReceived);
    sonar.sendRequest(widget.userData, widget.requestData);
    
    super.initState();
//    list = CardUtility.getContactModelList(null);
  }

  // Dispose Dependencies
  @override
  void dispose() {
    sonar.removeListener(_onSonarDataReceived);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// This routine handles all messages that are sent by the server.
  /// In this page, only the following 2 actions have to be processed
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _onSonarDataReceived(message) {
    // Update UI based on Status code sent from Server
    switch (message["status"]) {
      case 102:
        widget.title = message["status"].toString();
        widget.description = message["data"]["message"].toString();
        // force rebuild
        setState(() {});
        break;

      case 200:
        widget.title = message["status"].toString();
        widget.description = message["data"]["message"].toString();
        // force rebuild
        setState(() {});
        break;

      case 202:
        widget.title = message["status"].toString();
        widget.description = message["data"]["message"].toString();
        // force rebuild
        setState(() {
          Navigator.of(context).pop();
        });
        break;

      case 300:
        widget.title = message["status"].toString();
        widget.description = message["data"]["message"].toString();
        // force rebuild
        setState(() {});
        break;

      case 404:
        widget.title = message["status"].toString();
        widget.description = message["data"]["message"].toString();
        // force rebuild
        setState(() {});
        break;

      case 409:
        widget.title = message["status"].toString();
        widget.description = message["data"]["message"].toString();
        // force rebuild
        setState(() {});
        break;
    }
  }

  /// -----------------------------------------------------------
  /// If the user has not yet joined, let the user enter
  /// his/her name and join the list of players
  /// -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Row(children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        sonar.sendApprove();
                        //Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text("Approve"),
                    ),
                    FlatButton(
                      onPressed: () {
                        sonar.sendDecline();
                        //Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text("Decline"),
                    )
                  ])),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: Consts.avatarRadius,
          ),
        ),
        //...top circlular image part,
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
