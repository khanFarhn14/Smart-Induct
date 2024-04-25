// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_induct/bluetooth_data.dart';
import 'package:smart_induct/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<BluetoothDevice> bluetoothDevices = [];
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
          bluetoothDevices = devices;
          }
        );
        clearPrint(devices.length.toString());
      }else if(status.isDenied){
        clearPrint("Denied");
      }else{
        clearPrint(status.name);
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
      clearPrint("Data sent successfully");
    } catch (e) {
      clearPrint("Send data exception $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothData = Provider.of<BluetoothData>(context, listen: false);
    bool connectionLoading = false;
    bool disconnectionLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Induct', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),),
        centerTitle: true,
        toolbarHeight: 72,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<BluetoothData>(
              builder: (context, object, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(object.bluetoothConnectionStatus ? "Connected" : "Disconnected", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black87),),
                );
              }
            ),

            const SizedBox(height: 24,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Connection Button
                Consumer<BluetoothData>(
                  builder: (context, object, child) {
                    return StatefulBuilder(
                      builder: (context, myStateFunc) {
                        return ElevatedButton(
                          onPressed: object.bluetoothConnectionStatus ? null : () async{
                            // Started the loading
                            myStateFunc(() {
                              connectionLoading = true;
                            });
                    
                            // Checks the bluetooth connection
                            await bluetoothData.checkBluetooth();
                    
                            // Analyzing the result
                            if(bluetoothData.bluetoothStatus){
                              if(await connect(adr)){
                                bluetoothData.checkBluetoothConnection(connection.isConnected);
                              }else{
                                bluetoothData.checkBluetoothConnection(false);
                              }
                              myStateFunc((){
                                connectionLoading = false;
                              });
                            }else{
                              Widgets.showSnackBarForFeedback(cntxt: context, message: "Bluetooth is unavailable", isError: true);
                    
                              myStateFunc((){
                                connectionLoading = false;
                              });
                            }
                          },
                          child: connectionLoading ? Widgets.loading() : const Text("Connect"),
                        );
                      }
                    );
                  }
                ),

                // Disconnect Button
                Consumer<BluetoothData>(
                  builder: (context, object, child) {
                    return StatefulBuilder(
                      builder: (context, myStateFunc) {
                        return ElevatedButton(
                          onPressed: object.bluetoothConnectionStatus ? () async{
                            // Started the loading
                            myStateFunc(() {
                              disconnectionLoading = true;
                            });
                    
                            // Checks the bluetooth connection
                            await bluetoothData.checkBluetooth();
                    
                            // Analyzing the result
                            if(bluetoothData.bluetoothStatus){
                              if(await disconnect()){
                                bluetoothData.checkBluetoothConnection(false);
                              }else{
                                bluetoothData.checkBluetoothConnection(false);
                              }
                              myStateFunc((){
                                disconnectionLoading = false;
                              });
                            }else{
                              Widgets.showSnackBarForFeedback(cntxt: context, message: "Bluetooth is unavailable", isError: true);
                    
                              myStateFunc((){
                                disconnectionLoading = false;
                              });
                            }
                          } : null,
                          child: disconnectionLoading ? Widgets.loading() : const Text("Disconnect"),
                        );
                      }
                    );
                  }
                ),
              ],
            ),

            const SizedBox(height: 24,),

            Consumer<BluetoothData>(
              builder: (context, object, child){
                return ElevatedButton(
                  onPressed: object.bluetoothConnectionStatus ? () {
                    sendData("on");
                  } : null,
                  child: const Text(" ON ")
                );
              }
            ),

            const SizedBox(height: 12.0,),

            Consumer<BluetoothData>(
              builder: (context, object, child) {
                return ElevatedButton(
                  onPressed: object.bluetoothConnectionStatus ? () {
                    sendData("off");
                  } : null,
                  child: const Text("OFF"),
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Future<bool> connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      // sendData('111');
      //durum="Connected to the device";
      connection.input!.listen((Uint8List data) {
        //Data entry point
        // durum=ascii.decode(data);
      });

      Widgets.showSnackBarForFeedback(cntxt: context, message: "Connected successfully", isError: false);

      return true;

    } catch (exception) {
      clearPrint("Exception caugt in connect function: $exception");
      Widgets.showSnackBarForFeedback(cntxt: context, message: "An error occured", isError: true);
      return false;
      // durum="Cannot connect, exception occured";
    }
  }

  Future<bool> disconnect() async{
    try{
      connection.close();
      connection.dispose();
      Widgets.showSnackBarForFeedback(cntxt: context, message: "Disconnected successfully", isError: false);

      return true;
    }catch(exception){
      clearPrint("Exception caught when disconnect: $exception");
      Widgets.showSnackBarForFeedback(cntxt: context, message: "An error occured", isError: true);
      return false;
    }
  }

}

void clearPrint(String message){
  debugPrint("-------------------------------- $message --------------------------------");
}