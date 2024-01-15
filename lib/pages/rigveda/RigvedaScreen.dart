import 'package:flutter/material.dart';

class RigvedaHome extends StatelessWidget {
  final String title;
  const RigvedaHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rigveda'),
      ),
      body: Center(
        child: Text('Rigveda Home'),
      ),
    );
  }
}
