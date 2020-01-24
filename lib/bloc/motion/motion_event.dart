import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/models/models.dart';

abstract class MotionEvent extends Equatable {
  const MotionEvent();

  @override
  List<Object> get props => [];
}

// Informs Bloc Position Change Started
class Start extends MotionEvent {
  final Motion position;

  const Start({@required this.position});
}

// Informs Bloc to Pause (Should be during transfer)
class Pause extends MotionEvent {}

// Informs Bloc to Resume (After transfer complete)
class Resume extends MotionEvent {}

// Informs Bloc Position back to Zero
class Reset extends MotionEvent {}

// Informs Bloc Device in motion
class InMotion extends MotionEvent {
  final Motion position;

  const InMotion({@required this.position});

   @override
  List<Object> get props => [position];
}