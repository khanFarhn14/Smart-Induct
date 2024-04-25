import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<BluetoothDevice> _devices = [];
  late BluetoothConnection connection;
  String adr = "00:00:13:00:18:4C";

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try{
      var status = await Permission.bluetoothConnect.request();
      if(status.isGranted){
        List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
        setState(() {
          _devices = devices;
          }
        );
        clearPrint(devices.length.toString());
      }else if(status.isDenied){

      }
    }catch(exception){
      clearPrint("In _loadDevices exception caught is: $exception");
    }
  }

  Future<void> sendData(String data)  async {
    data = data.trim();
    try {
      List<int> list = data.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      connection.output.add(bytes);
      await connection.output.allSent;
      if (kDebugMode) {
        clearPrint("Data sent successfully");
      }
    } catch (e) {
      clearPrint("Send data exception $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Induct', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          children: [
            const Text("MAC Adress: 00:21:07:00:50:69"),

            ElevatedButton(
              child: const Text("Connect"),
              onPressed: () {
                // sendData("connect");
                connect(adr);
              },
            ),

            const SizedBox(height: 30.0,),

            ElevatedButton(
              child: const Text(" ON "),
              onPressed: () {
                sendData("on");
              },
            ),

            const SizedBox(height: 10.0,),

            ElevatedButton(
              child: const Text("OFF"),
              onPressed: () {
                sendData("off");
              },
            ),
          ],
        ),
      )
    );
  }

  Future connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      // sendData('111');
      //durum="Connected to the device";
      connection.input!.listen((Uint8List data) {
        //Data entry point
        // durum=ascii.decode(data);
      });

    } catch (exception) {
      clearPrint("Exception caugt in connect function: $exception");
      // durum="Cannot connect, exception occured";
    }
  }
}

void clearPrint(String message){
  debugPrint("-------------------------------- $message --------------------------------");
}