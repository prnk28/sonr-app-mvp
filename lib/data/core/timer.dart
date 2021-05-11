import 'dart:async';

typedef BoolFunction = bool Function();

class FunctionTimer {
  // Properties
  final Duration deadline;
  final Duration interval;
  final completer = Completer<bool>();
  bool get isRunning => _isRunning;

  // References
  bool _isRunning = false;
  Timer? _timer;
  double _counter = 0;
  late int _intervalValue;
  int? _deadlineValue;

  FunctionTimer({required this.deadline, required this.interval}) {
    _deadlineValue = this.deadline.inMilliseconds;
    _intervalValue = this.interval.inMilliseconds;
  }

  Future<bool> start({required BoolFunction isValid, required Function onComplete}) {
    if (!isRunning) {
      _setTimer(isValid, onComplete);
    }
    return completer.future;
  }

  void _setTimer(BoolFunction isValid, Function onComplete) {
    _isRunning = true;

    _timer = Timer.periodic(interval, (_) {
      // Add MS to Counter
      _counter += _intervalValue;

      // Check if Facing
      if (_counter == _deadlineValue) {
        if (isValid()) {
          onComplete();
          completer.complete(true);
        } else {
          completer.complete(false);
          _resetTimer();
        }
      }
    });
  }

  // # Stop Timer for Facing Check
  void _resetTimer() {
    if (_timer != null) {
      _isRunning = false;
      _timer!.cancel();
      _timer = null;
      _counter = 0;
    }
  }

  void stop() {
    _resetTimer();
  }
}
