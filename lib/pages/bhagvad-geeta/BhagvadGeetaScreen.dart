import 'package:flutter/material.dart';

class BhagvadGeetaHome extends StatelessWidget {
  final String title;
  const BhagvadGeetaHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bhagvad Geeta'),
      ),
      body: Center(
        child: Text('Bhagvad Geeta Home'),
      ),
    );
  }
}
