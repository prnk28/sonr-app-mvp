import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/models/models.dart';

abstract class OrientationEvent extends Equatable {
  const OrientationEvent();

  @override
  List<Object> get props => [];
}

// Informs Bloc Position Change Started
class Start extends OrientationEvent {
  final Motion position;

  const Start({@required this.position});
}

// Informs Bloc to Pause (Should be during transfer)
class Pause extends OrientationEvent {}

// Informs Bloc to Resume (After transfer complete)
class Resume extends OrientationEvent {}

// Informs Bloc Device in motion
class InMotion extends OrientationEvent {
  final Motion position;

  const InMotion({@required this.position});

   @override
  List<Object> get props => [position];
}