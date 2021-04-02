import 'dart:async';
import 'package:sonr_app/theme/theme.dart';

typedef BoolFunction = bool Function();

class TimerService {
  // Properties
  final Duration deadline;
  final Duration interval;
  final completer = new Completer<bool>();

  // References
  Timer _timer;
  double _counter;
  int _intervalValue;
  int _deadlineValue;

  TimerService({@required this.deadline, @required this.interval}) {
    _deadlineValue = this.deadline.inMilliseconds;
    _intervalValue = this.interval.inMilliseconds;
  }

  Future<bool> start({BoolFunction isValid}) {
    _timer = Timer.periodic(interval, (_) {
      // Add MS to Counter
      _counter = _counter += _intervalValue;

      // Check if Facing
      if (_counter == _deadlineValue) {
        if (isValid != null) {
          if (isValid()) {
            completer.complete(true);
          } else {
            completer.complete(false);
            _resetTimer();
          }
        } else {
          completer.complete(true);
          _resetTimer();
        }
      }
    });
    return completer.future;
  }

  // # Stop Timer for Facing Check
  void _resetTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _counter = 0;
    }
  }
}
