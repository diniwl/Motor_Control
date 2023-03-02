import 'package:flutter/material.dart';
import 'navigation.dart';

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
      home: Navigation(),
    );
  }
}