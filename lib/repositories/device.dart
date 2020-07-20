import '../core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repositories/repositories.dart';

class Device {
  // Properties
  Direction lastDirection;
  Motion currentMotion = Motion.create();
  Soundpool soundpool = new Soundpool(streamType: StreamType.music);

  // ** CONSTRUCTOR
  Device(SonarBloc bloc, Connection connection) {
    // ** Accelerometer Events **
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      currentMotion = Motion.create(a: newData);
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((newData) {
      // Check Status
      if (connection.noContact()) {
        // Initialize Direction
        var newDirection = Direction.create(
            degrees: newData, accelerometerX: currentMotion.accelX);

        // Check Sender Threshold
        if (currentMotion.state == Orientation.Tilt) {
          // Set Sender
          bloc.circle.status = "Sender";

          // Check Valid
          if (lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - lastDirection.degrees;

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
        else if (currentMotion.state == Orientation.LandscapeLeft ||
            currentMotion.state == Orientation.LandscapeRight) {
          // Set Receiver
          bloc.circle.status = "Receiver";

          // Check Valid
          if (lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - lastDirection.degrees;
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
}
