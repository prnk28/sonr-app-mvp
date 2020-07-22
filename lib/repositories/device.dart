import 'package:sonar_app/core/core.dart';

class Device {
  Device(SonarBloc bloc) {
    // ** Accelerometer Events **
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      bloc.currentMotion = Motion.create(a: newData);
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((newData) {
      // Check Status
      if (!bloc.offered && !bloc.requested) {
        // Initialize Direction
        var newDirection = Direction.create(
            degrees: newData, accelerometerX: bloc.currentMotion.accelX);

        // Check Sender Threshold
        if (bloc.currentMotion.state == Orientation.Tilt) {
          // Set Sender
          bloc.circle.status = "Sender";

          // Check Valid
          if (bloc.lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - bloc.lastDirection.degrees;

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
        else if (bloc.currentMotion.state == Orientation.LandscapeLeft ||
            bloc.currentMotion.state == Orientation.LandscapeRight) {
          // Set Receiver
          bloc.circle.status = "Receiver";

          // Check Valid
          if (bloc.lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - bloc.lastDirection.degrees;
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
