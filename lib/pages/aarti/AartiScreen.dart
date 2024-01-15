import 'package:flutter/material.dart';

class AartiHome extends StatelessWidget {
  final String title;
  const AartiHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aarti'),
      ),
      body: Center(
        child: Text('Aarti Home'),
      ),
    );
  }
}
