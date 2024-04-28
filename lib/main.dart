import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_induct/bluetooth_data.dart';
import 'package:smart_induct/home.dart';
import 'package:smart_induct/timer_data.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> BluetoothData()),
        ChangeNotifierProvider(create: (context)=> TimerData()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Induct',
        home: HomePage(),
      ),
    );
  }
}