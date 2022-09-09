import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'screens/scan_screen.dart';
import 'screens/bluetoothOff_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    color: Colors.lightBlue,
    home: StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          return ScanScreen(title: "Find Devices");
        }
        return BluetoothOffScreen(state: state);
      }, 
      ),
  ));
}

