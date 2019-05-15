import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_frontend/sonar/sonar_communication.dart';

class SonarBox extends StatefulWidget {
  SonarBox({Key key}) : super(key: key);
  _SonarBoxState createState() => _SonarBoxState();
}

class _SonarBoxState extends State<SonarBox> {
  // Variables
  String playerName;
  List<dynamic> playersList = <dynamic>[];

  // Initialize
  @override
  void initState() {
    super.initState();
    sonar.addListener(_onSonarDataReceived);
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
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;

      case 200:
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;

      case 202:
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;

      case 300:
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;

      case 404:
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;

      case 409:
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;
    }
  }

  /// -----------------------------------------------------------
  /// If the user has not yet joined, let the user enter
  /// his/her name and join the list of players
  /// -----------------------------------------------------------
  Widget _buildJoin() {
    if (sonar.playerName != "") {
      return new Container();
    }
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: 'Enter your name',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              icon: const Icon(Icons.person),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
              onPressed: _onGameJoin,
              child: new Text('Join...'),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------
  /// The user wants to join, so let's send his/her name
  /// As the user has a name, we may now show the other players
  /// ------------------------------------------------------
  _onSonarRequest() {
    sonar.send('request',);
	
    /// Force a rebuild
    setState(() {});
  }

  /// ------------------------------------------------------
  /// Builds the list of players
  /// ------------------------------------------------------
  Widget _playersList() {
    ///
    /// If the user has not yet joined, do not display
    /// the list of players
    ///
    if (sonar.playerName == "") {
      return new Container();
    }

    ///
    /// Display the list of players.
    /// For each of them, put a Button that could be used
    /// to launch a new game
    ///
    List<Widget> children = playersList.map((playerInfo) {
        return new ListTile(
          title: new Text(playerInfo["name"]),
          trailing: new RaisedButton(
            onPressed: (){
              _onPlayGame(playerInfo["name"], playerInfo["id"]);
            },
            child: new Text('Play'),
          ),
        );
      }).toList();

    return new Column(
      children: children,
    );
  }

  /// --------------------------------------------------------------
  /// We launch a new Game, we need to:
  ///    * send the action "new_game", together with the ID
  ///      of the opponent we choosed
  ///    * redirect to the game board
  ///      As we are the game initiator, we will play with the "X"
  /// --------------------------------------------------------------
  _onPlayGame(String opponentName, String opponentId){
    // We need to send the opponentId to initiate a new game
    sonar.send('new_game', opponentId);
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('TicTacToe'),
        ),
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildJoin(),
              new Text('List of players:'),
              _playersList(),
            ],
          ),
        ),
      ),
    );
  }
}
}