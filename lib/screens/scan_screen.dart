import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'device_screen.dart';

/*
class ScanScreen extends StatefulWidget {
  ScanScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}


class _ScanScreenState extends State<ScanScreen> {
  late BluetoothDevice targetDevice;
  List<BluetoothService> _services = [];

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name.contains("Your Device name!!!")) {
          _addDeviceTolist(result.device);
          targetDevice = result.device;
          widget.flutterBlue.stopScan();
        }
      }
    });
    widget.flutterBlue.startScan();
  }

  Widget _buildTargetDeviceView() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      height: 150,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20.0),
                Text(
                  targetDevice.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  targetDevice.id.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black87,
            ),
            child: const Text(
              'CONNECT',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await targetDevice.connect();
              _services = await targetDevice.discoverServices();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return DeviceScreen(device: targetDevice, services: _services,);
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: (widget.devicesList.isNotEmpty)
            ? _buildTargetDeviceView()
            : Container(),
      );
}
*/

class ScanScreen extends StatefulWidget {
  ScanScreen({ Key? key, required this.title }) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  List<BluetoothService> _services = [];

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    */
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });

    widget.flutterBlue.startScan();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              const SizedBox(height: 30.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      device.name == '' ? 'Unknown Device' : device.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      device.id.toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                ),
                child: const Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  await device.connect();
                  _services = await device.discoverServices();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DeviceScreen(device: device, services: _services,);
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: _buildListViewOfDevices(),
      );
}