import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothData extends ChangeNotifier{
  bool _isBluetoothOn = false;
  bool _isBluetoothConnected = false;
  List<int> temperatures = [0, 1100, 1000, 800, 500, 300, 100];
  int currentTemperature = 0;

  bool get bluetoothStatus => _isBluetoothOn;
  
  Future<void> checkBluetooth() async {
    bool bluetoothStatus = await FlutterBlue.instance.isOn;
    _isBluetoothOn = bluetoothStatus;
    notifyListeners();
  }

  bool get bluetoothConnectionStatus => _isBluetoothConnected;
  
  checkBluetoothConnection(bool status) {
    _isBluetoothConnected = status;
    notifyListeners();
  }

  startTemperature(){
    currentTemperature = 1;
    notifyListeners();
  }

  resetTemperature(){
    currentTemperature = 0;
    notifyListeners();
  }

  decreementTemperature(){
    if(currentTemperature < temperatures.length){
      currentTemperature++;
      notifyListeners();
    }
  }
}