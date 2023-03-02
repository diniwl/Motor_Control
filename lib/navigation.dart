import 'package:flutter/material.dart';
import 'package:motorcontrol/bluetooth.dart';
import 'package:motorcontrol/home.dart';
import 'package:motorcontrol/voice_command.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> body = [HomePage(), BluetoothPage(), VoiceCommand()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.blueGrey[200],
        selectedItemColor: Colors.blueAccent[700],
        items: [
          // Home
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(Icons.bluetooth),
              label: "Bluetooth"),

          BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: "VC"),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
