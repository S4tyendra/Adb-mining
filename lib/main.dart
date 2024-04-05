import 'package:adb_app/screens/1DevicelistScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const GetCupertinoApp(
      title: 'ADB Manager',
      home: DeviceListScreen(),
      popGesture: true,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        applyThemeToAll: true,
      ),
    );
  }
}
