import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothData extends ChangeNotifier{
  bool _isBluetoothOn = false;
  bool _isBluetoothConnected = false;

  bool get bluetoothStatus => _isBluetoothOn;
  
  Future<void> checkBluetooth() async {
    bool bluetoothStatus = await FlutterBlue.instance.isOn;
    _isBluetoothOn = bluetoothStatus;
    notifyListeners();
  }

  bool get bluetoothConnectionStatus => _isBluetoothConnected;
  
  Future<void> checkBluetoothConnection(bool status) async {
    _isBluetoothConnected = status;
    notifyListeners();
  }
}