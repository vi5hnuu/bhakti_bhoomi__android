import 'package:flutter/material.dart';

class ValmikiRamayanHome extends StatelessWidget {
  final String title;
  const ValmikiRamayanHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valmiki Ramayan'),
      ),
      body: Center(
        child: Text('Valmiki Ramayan Home'),
      ),
    );
  }
}
