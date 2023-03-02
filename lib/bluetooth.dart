import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice? _device;
  BluetoothConnection? _connection;
  bool _isConnecting = false;
  bool _isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _connect() async {
    setState(() {
      _isConnecting = true;
    });

    if (_device == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No device selected"),
            content: Text("Please select a device to connect to"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        _isConnecting = false;
      });
      return;
    }

    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(_device!.address);
      print('Connected to the device ${_device!.name}');
      setState(() {
        _connection = connection;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        _isConnecting = false;
      });
    }

    setState(() {
      _isConnecting = false;
    });
  }

  void _disconnect() async {
    setState(() {
      _isDisconnecting = true;
    });
    await _connection!.close();
    print('Disconnected from the device ${_device!.name}');
    setState(() {
      _isDisconnecting = false;
      _connection = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent[700],
        title: Text(
          "DC Motor Control App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Bluetooth Status: ${_bluetoothState.toString()}",
                style: TextStyle(
                    color: Colors.blueAccent[700],
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text(
                _isConnecting ? 'Connecting...' : 'Connect',
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: () async {
                if (_bluetoothState == BluetoothState.STATE_ON) {
                  _connect();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Bluetooth is off"),
                        content: Text("Please turn on Bluetooth to connect"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  _disconnect();
                },
                child: Text(
                  _isDisconnecting ? "Disconnecting..." : "Disconnect",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 20.0,
            ),
            Text(
              _connection != null
                  ? 'Connected to ${_device!.name}'
                  : 'Not connected',
              style: TextStyle(
                  color: Colors.blueAccent[700],
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.bluetooth_searching),
        onPressed: () async {
          List<BluetoothDevice> devices =
              await FlutterBluetoothSerial.instance.getBondedDevices();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Choose a device"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: devices
                      .map(
                        (device) => ListTile(
                          title: Text(device.name ?? "Unknown Device"),
                          subtitle: Text(device.address),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _device = device;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
