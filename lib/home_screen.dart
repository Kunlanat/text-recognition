import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/camera_screen.dart';
import 'package:flutter_text_recognition/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return UICameraScreen(cameras: cameras);
  }
}
