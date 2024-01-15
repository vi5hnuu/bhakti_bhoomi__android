import 'package:flutter/material.dart';

class ChalisaHome extends StatelessWidget {
  final String title;
  const ChalisaHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chalisa'),
      ),
      body: Center(
        child: Text('Chalisa Home'),
      ),
    );
  }
}
