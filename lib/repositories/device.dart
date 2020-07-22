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
        if (this.isSending()) {
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
        else if (this.isReceiving()) {
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

  // Checks if New Direction is Changed and Sets it
  void updateDirection(Direction newDirection) {
    if (this.lastDirection != newDirection) {
      this.lastDirection = newDirection;
    }
  }

  // BOOL: Checks if Tilted are Receiving
  bool isSearching() {
    return this.currentMotion.state == Orientation.Tilt ||
        this.currentMotion.state == Orientation.LandscapeLeft ||
        this.currentMotion.state == Orientation.LandscapeRight;
  }

  // BOOL: Checks if Tilted
  bool isSending() {
    return this.currentMotion.state == Orientation.Tilt;
  }

  // BOOL: Checks if Landscape
  bool isReceiving() {
    return this.currentMotion.state == Orientation.LandscapeLeft ||
        this.currentMotion.state == Orientation.LandscapeRight;
  }
}
