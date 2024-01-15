import 'package:flutter/material.dart';

class YogaSutraHome extends StatelessWidget {
  final String title;
  const YogaSutraHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YogaSutra'),
      ),
      body: Center(
        child: Text('YogaSutra Home'),
      ),
    );
  }
}
