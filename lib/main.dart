import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool ble = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DC Motor Control",
      home: Scaffold(
        
        // App Bar
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          title: Text("DC Motor Control App", 
          style: TextStyle(
            color: Colors.white,
          ),),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // Bluetooth
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.bluetooth,
                          color: Colors.blueAccent[700]),
                          Text("Bluetooth"),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 50, 0)),
                          Switch(
                            value: ble, 
                            activeColor: Colors.blueAccent[700],
                            onChanged: (bool value) {
                              setState(() {
                                ble = value;
                              });
                            }
                            )
                        ],
                      ),
                    ),
                  ),
            
                  // Clock Widget
                  Card(
                    child: Container(
                      child: Text("Timer"),
                    ),
                  ),
            
                  // Form Widget
                  Form(child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Motor Turns"
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Timer"
                        ),
                      )
                    ],
                  )),
            
                  // Buttons
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
            
                          }, 
                          child: Text("OK")),
                      ),
                        ElevatedButton(onPressed: () {
            
                        }, child: Text("Stop/Reset"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}