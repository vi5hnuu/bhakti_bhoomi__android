import 'package:flutter/material.dart';

class MahabharatHome extends StatelessWidget {
  final String title;
  const MahabharatHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahabharat'),
      ),
      body: Center(
        child: Text('Mahabharat Home'),
      ),
    );
  }
}
