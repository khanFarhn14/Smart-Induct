import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smart_induct/home.dart';

class TimerData extends ChangeNotifier{

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool isRunning = false;
  int riceMinute = 1;
  bool isRiceCooking = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds = _stopwatch.elapsedMilliseconds ~/ 1000;
      minutes = seconds ~/ 60;
      // hours = minutes ~/ 60;

      seconds = seconds % 60;
      minutes = minutes % 60;
      notifyListeners();
    });
    clearPrint("Timer");
    isRunning = true;
    _stopwatch.start();
  }

  void resetTimer() {
    isRiceCooking = false;
    _timer.cancel();
    isRunning = false;
    _stopwatch.stop();
    _stopwatch.reset();
    hours = 0;
    minutes = 0;
    seconds = 0;
    notifyListeners();
  }

  void startCountdown() {
    isRiceCooking = true;
    minutes = riceMinute;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if(seconds < 0){
        seconds = 59;
        minutes--;
      }
      if(minutes < 0){
        resetTimer();
      }
      notifyListeners();
    });
  }
}