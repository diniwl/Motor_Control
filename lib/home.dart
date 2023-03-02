import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'package:analog_clock/analog_clock.dart';

BluetoothConnection? _connection;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String _motorTurns = '';
  String _minutes = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DC Motor Control",
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          elevation: 0,
          title: Text(
            "DC Motor Control App",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("Welcome!",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blueAccent[700],
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 30)),
                    SizedBox(
                      height: 40,
                    ),

                    AnalogClock(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle
                      ),
                      showSecondHand: true,
                      datetime: DateTime.now(),
                      isLive: true,
                      hourHandColor: Colors.black,
                      minuteHandColor: Colors.red,
                      height: 200.0,
                      width: 200.0,
                    ),

                    // Form Widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Turn on Motor",
                            style: TextStyle(
                                color: Colors.blueAccent[700],
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          width: 50,
                          height: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            controller: _controller,
                            onChanged: (value) {
                              _motorTurns = value;
                            },
                          ),
                        ),
                        Text("Times",
                            style: TextStyle(
                                color: Colors.blueAccent[700],
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("In Every",
                            style: TextStyle(
                                color: Colors.blueAccent[700],
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          width: 50,
                          height: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            controller: _controller,
                            onChanged: (value) {
                              _minutes = value;
                            },
                          ),
                        ),
                        Text("Minutes",
                            style: TextStyle(
                                color: Colors.blueAccent[700],
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_motorTurns.isNotEmpty) {
                                // Convert the text to bytes using the ASCII encoding
                                List<int> bytes = _motorTurns.codeUnits;

                                if (_minutes.isNotEmpty) {
                                  List<int> bytes = _minutes.codeUnits;
                                }
                                Uint8List data = Uint8List.fromList(bytes);

                                // Check if a Bluetooth connection is available
                                if (_connection != null) {
                                  // Send the bytes to the Arduino
                                  _connection!.output.add(data);

                                  // Flush the output buffer to ensure that all bytes are sent
                                  await _connection!.output.allSent;

                                  // Display a success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Text sent successfully')),
                                  );
                                } else {
                                  // Display an error message if no connection is available
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('No Bluetooth connection')),
                                  );
                                }
                              }
                            },
                            child: Text("OK",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: Text("Stop/Reset",
                                style: TextStyle(color: Colors.white)))
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
