import 'package:flutter/material.dart';

class ChanakyaNeetiHome extends StatelessWidget {
  final String title;
  const ChanakyaNeetiHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chanakya Neeti'),
      ),
      body: Center(
        child: Text('Chanakya Neeti Home'),
      ),
    );
  }
}
