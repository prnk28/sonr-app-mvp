// Remote Packages
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as Math;

// Local Classes
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


    // JOIN Server
    //sonar.ws.msgJoin();
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
    print("build");
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
            PermissionHandler()
                .requestPermissions([PermissionGroup.locationWhenInUse]);
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
  double _direction;

  final Position _position;
  String _address = '';

  @override
  void initState() {
    super.initState();

    // Use Compass
    FlutterCompass.events.listen((double direction) {
      setState(() {
        // Set New Direction
        _direction = direction;

        // Create Model
        DirectionModel model = new DirectionModel(_direction);
        log(model.toJSON());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Row row = Row(
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
              StreamBuilder<double>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          );
        }

        double direction = snapshot.data;

        return Container(
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: ((direction ?? 0) * (Math.pi / 180) * -1),
            child: Icon(Icons.arrow_upward),
          ),
        );
      },
    )
            ]),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  _position.timestamp.toLocal().toString(),
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                )
              ]),
        ),
      ],
    );

    return ListTile(
      onTap: _onTap,
      title: row,
      subtitle: Text(_address),
    );
  }

  Future<void> _onTap() async {
    String address = 'unknown';
    final List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(_position.latitude, _position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      address = _generateAddressString(placemarks.first);
    }

    setState(() {
      _address = '$address';
    });
  }

    _generateAddressString(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';

    return '$name, $city, $state, $country';
  }
}
