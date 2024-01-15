import 'package:flutter/material.dart';

class RamcharitmanasHome extends StatelessWidget {
  final String title;
  const RamcharitmanasHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramcharitmanas'),
      ),
      body: Center(
        child: Text('Ramcharitmanas Home'),
      ),
    );
  }
}
