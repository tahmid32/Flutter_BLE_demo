import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key, required this.device, required this.services})
      : super(key: key);

  final BluetoothDevice device;
  final List<BluetoothService> services;
  //final readValues = {};

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<int> readResult = [];
  var readValuesInt = {};    // map to store characteristic values through read or notification operation 
                             // in Decimal format
  var readValuesString = {}; // map to store characteristic values through read operation in ASCII format.
  final _writeController = TextEditingController();
  bool isDialogShowing = false; // boolean variable to track whether the Alert Dialog is open or not

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose(); 
  }

  List<ElevatedButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ElevatedButtonTheme> buttons = <ElevatedButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.black45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: const Text(
                'READ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                readResult = await characteristic.read();
                setState(() {
                  readValuesInt[characteristic.uuid] = readResult;
                  readValuesString[characteristic.uuid] =
                      utf8.decode(readResult);
                });
              },
            ),
          ),
        ),
      );
    }

    if (characteristic.properties.write) {
      buttons.add(
        ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.black45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: const Text(
                'WRITE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Write"),
                      content: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(controller: _writeController),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Send"),
                          onPressed: () {
                            characteristic.write(
                                utf8.encode(_writeController.value.text));
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    if (characteristic.properties.notify) {
      buttons.add(
        ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.black45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: const Text(
                'NOTIFY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  setState(() {
                    readValuesInt[characteristic.uuid] = value;
                  });
            
            // With each incoming notification, show the notification value in a Dialog box if and only if 
            // the dialog box is not already open in the screen. If the dialog box is already open in the 
            // screen, then notification values will not be updated in the dialog box.
            
                  if (isDialogShowing == false) {
                    isDialogShowing = true;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Notification Received!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                            content: Row(
                              children: <Widget>[
                                Text("Value: " +
                                    readValuesInt[characteristic.uuid]
                                        .toString()),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  isDialogShowing = false;
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        });
                  }
                });
              },
            ),
          ),
        ),
      );
    }

    if (characteristic.properties.indicate) {
      buttons.add(
        ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.black45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              child: const Text(
                'INDICATE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  setState(() {
                    readValuesInt[characteristic.uuid] = value;
                  });

             // With each incoming indication, show the indication value in a Dialog box if and only if 
             // the dialog box is not already open in the screen. If the dialog box is already open in the 
             // screen, then indication values will not be updated in the dialog box.
      
                  if (isDialogShowing == false) {
                    isDialogShowing = true;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Indication Received!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                            content: Row(
                              children: <Widget>[
                                Text("Value: " +
                                    readValuesInt[characteristic.uuid]
                                        .toString()),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  isDialogShowing = false;
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        });
                  }
                });
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  Widget buildDefaultCharValueView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Value: '),
        Text('ASCII Value: '),
      ],
    );
  }

  Widget buildActualCharValueView(BluetoothCharacteristic characteristic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Value: ' + readValuesInt[characteristic.uuid].toString()),
        Text((readValuesString[characteristic.uuid] != null)
            ? 'ASCII Value: ' + readValuesString[characteristic.uuid]
            : 'ASCII Value:'),
      ],
    );
  }

  ListView _buildConnectedDeviceView() {
    List<Container> containers = <Container>[];
    for (BluetoothService service in widget.services) {
      List<Widget> characteristicsWidget = <Widget>[];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Characteristic",
                          style: TextStyle(color: Colors.blueGrey[700]),
                        ),
                        Row(
                          children: <Widget>[
                            const Text(
                              'UUID: ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              (characteristic.uuid.toString().substring(0, 4) ==
                                      '0000')
                                  ? '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}'
                                  : characteristic.uuid.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                  ..._buildReadWriteNotifyButton(characteristic)
                  ],
                ),
                Row(
                  children: <Widget>[
                    (readValuesInt[characteristic.uuid] != null)
                        ? buildActualCharValueView(characteristic)
                        : buildDefaultCharValueView(),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }

      containers.add(
        Container(
          child: ExpansionTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (service.isPrimary)
                        ? 'Primary Service'
                        : 'Secondary service',
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                  Text(
                    (service.uuid.toString().substring(0, 4) == '0000')
                        ? '0x${service.uuid.toString().toUpperCase().substring(4, 8)}'
                        : service.uuid.toString(),
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        ...containers
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        centerTitle: true,
      ),
      body: _buildConnectedDeviceView(),
    );
  }
}
