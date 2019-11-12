// Remote Packages
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as Math;

// Local Classes
import '../model/location_model.dart';
import '../model/profile_model.dart';
import '../widgets/placeholder_widget.dart';
import '../core/sonar_client.dart';
import '../model/direction_model.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State {
  @override
  void initState() {
    super.initState();

    // Connect to Server
    sonar.ws.initialize();
  }

  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
      final Stream<Position> positionStream =
          Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen(
          (Position position) => setState(() => _positions.add(position)));
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4BBEE3 Zima Blue
    return Scaffold(
      body: FutureBuilder<GeolocationStatus>(
          future: Geolocator().checkGeolocationPermissionStatus(),
          builder: (BuildContext context,
              AsyncSnapshot<GeolocationStatus> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == GeolocationStatus.denied) {
              return const PlaceholderWidget('Location services disabled',
                  'Enable location services for this App using the device settings.');
            }

            return _buildListView();
          }),
      appBar: AppBar(
        title: Text("Sonar"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: MaterialButton(
          child: Icon(Icons.location_on),
          onPressed: () {
            // Join Lobby
            ProfileModel profile =
                new ProfileModel("firstName", "lastName", "profilePicture");
            sonar.ws.msgJoin(profile);
          },
        ),
      ),
    );
  }

  Widget _buildListView() {
    final List<Widget> listItems = <Widget>[
      ListTile(
        title: RaisedButton(
          child: _buildButtonText(),
          color: _determineButtonColor(),
          padding: const EdgeInsets.all(8.0),
          onPressed: _toggleListening,
        ),
      ),
    ];

    listItems.addAll(_positions
        .map((Position position) => PositionListItem(position))
        .toList());

    return ListView(
      children: listItems,
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Widget _buildButtonText() {
    return Text(_isListening() ? 'Stop listening' : 'Start listening');
  }

  Color _determineButtonColor() {
    return _isListening() ? Colors.red : Colors.green;
  }
}

class PositionListItem extends StatefulWidget {
  const PositionListItem(this._position);
  final Position _position;

  @override
  State<PositionListItem> createState() => PositionListItemState(_position);
}

class PositionListItemState extends State<PositionListItem> {
  PositionListItemState(this._position);
  final Position _position;
  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    //Accelerometer events
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Get Accelerometer Values
        _accelerometerValues = <double>[event.x, event.y, event.z];

        // Check Device Position
        sonar.wsStatus = sonar.location.checkDevicePosition(_accelerometerValues);
      });
    }));

    // Update Direction
    FlutterCompass.events.listen((double direction) {
      setState(() {
        sonar.currentDirection = new DirectionModel(direction);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sensory Input
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    // Create Cell
    return ListTile(
      title: Row(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Acc: ${_position.accuracy}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'Lat: ${_position.latitude}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'Lon: ${_position.longitude}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'Alt: ${_position.altitude}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text('Accelerometer: $accelerometer'),
                Text('Direction: ' + sonar.currentDirection.degrees.toString()),
                Text(
                    'Antipodal: ' + sonar.currentDirection.antipodalDegrees.toString()),
                Text('Status: ' + sonar.wsStatus.toString()),
              ]),
        ],
      ),
    );
  }
}
