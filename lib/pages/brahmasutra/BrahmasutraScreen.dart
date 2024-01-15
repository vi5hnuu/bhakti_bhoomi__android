import 'package:flutter/material.dart';

class BrahmasutraHome extends StatelessWidget {
  final String title;
  const BrahmasutraHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brahmasutra'),
      ),
      body: Center(
        child: Text('Brahmasutra Home'),
      ),
    );
  }
}
