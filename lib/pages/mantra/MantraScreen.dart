import 'package:flutter/material.dart';

class MantraHome extends StatelessWidget {
  final String title;
  const MantraHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mantra'),
      ),
      body: Center(
        child: Text('Mantra Home'),
      ),
    );
  }
}
