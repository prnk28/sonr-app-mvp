import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

enum SonarStatus { RECEIVER, SENDER, DEFAULT }

class Device {
  // References
  SonarBloc bloc;
  Direction direction;
  Motion motion = Motion.create();
  SonarStatus status;

  Device(this.bloc) {
    // ** Accelerometer Events **
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      motion = Motion.create(a: newData);
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((newData) {
      // Check Status
      if (bloc.connection.noContact()) {
        // Initialize Direction
        var newDirection =
            Direction.create(degrees: newData, accelerometerX: motion.accelX);

        // Check Sender Threshold
        if (motion.state == Orientation.Tilt) {
          // Set Sender
          this.status = SonarStatus.SENDER;

          // Check Valid
          if (direction != null) {
            // Generate Difference
            var difference = newDirection.degrees - direction.degrees;

            // Threshold
            if (difference.abs() > 5) {
              // Modify Circle
              bloc.circle.modify(newDirection);

              // Refresh Inputs
              bloc.add(Refresh(newDirection: newDirection));
            }
          }
          bloc.add(Refresh(newDirection: newDirection));
        }
        // Check Receiver Threshold
        else if (motion.state == Orientation.LandscapeLeft ||
            motion.state == Orientation.LandscapeRight) {
          // Set Receiver
          this.status = SonarStatus.RECEIVER;

          // Check Valid
          if (direction != null) {
            // Generate Difference
            var difference = newDirection.degrees - direction.degrees;
            if (difference.abs() > 10) {
              // Modify Circle
              bloc.circle.modify(newDirection);
              // Refresh Inputs
              bloc.add(Refresh(newDirection: newDirection));
            }
          }
          bloc.add(Refresh(newDirection: newDirection));
        }
      }
    });
  }

  // BOOL: Check if Tilted or Landscape
  bool isSearching() {
    return motion.state == Orientation.Tilt ||
        motion.state == Orientation.LandscapeLeft ||
        motion.state == Orientation.LandscapeRight;
  }

  // BOOL: Check if Tilted
  bool isSending() {
    return motion.state == Orientation.Tilt;
  }

  // BOOL: Check if Landscape
  bool isReceiving() {
    return motion.state == Orientation.LandscapeLeft ||
        motion.state == Orientation.LandscapeRight;
  }
}
