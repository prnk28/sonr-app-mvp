import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TimerService extends GetxService {
  // Properties
  final elapsed = Duration.zero.obs;
  final isRunning = false.obs;
  final timerIntervals = Map<Duration, bool>().obs;
  final progress = 0.0.obs;

  // Refrences
  Stopwatch _watch;
  Timer _timer;
  Duration _stopTime;

  Future<TimerService> init() async {
    _watch = Stopwatch();
    return this;
  }

  // ^ Method to Start Timer Service ^ //
  void start(
      {Duration ticker = const Duration(milliseconds: 50),
      List<Duration> intervals = const <Duration>[],
      Duration stopTime = const Duration(seconds: 5)}) {
    // Cancel if Active
    if (_timer != null) return;

    // Begin Timer
    _timer = Timer.periodic(ticker, _onTick);
    _watch.start();
    isRunning(true);

    // Set Properties
    _stopTime = stopTime;

    // Create Intervals
    intervals.forEach((time) {
      timerIntervals[time] = false;
    });
  }

  // ^ Method to Stop Timer Service ^ //
  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    elapsed(_watch.elapsed);
    isRunning(false);
  }

  // ^ Method to Reset Timer Service ^ //
  void reset() {
    stop();
    _watch.reset();
    elapsed(Duration.zero);
    isRunning(false);
    progress(0.0);
    timerIntervals.clear();
    timerIntervals.refresh();
  }

  // ^ Method to Convert Elapsed Duration to Percentage ^ //
  double durationToPercentage(Duration duration, {@required Duration maxDuration}) {
    return (duration.inMilliseconds / maxDuration.inMilliseconds).toDouble();
  }

  // @ Method to Handle Timer Ticker
  void _onTick(Timer timer) {
    // @ Set Elapsed
    elapsed(_watch.elapsed);
    progress(durationToPercentage(_watch.elapsed, maxDuration: _stopTime));

    // @ Update Intervals
    timerIntervals.forEach((time, status) {
      // Check if Interval Met
      if (time.inMilliseconds <= _watch.elapsed.inMilliseconds) {
        timerIntervals[time] = true;
      }
    });

    // @ Check Completed
    if (_watch.elapsed >= _stopTime) {
      stop();
    }

    // @ Notify Listeners
    timerIntervals.refresh();
  }
}
