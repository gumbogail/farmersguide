import 'package:flutter/material.dart';
// Prediction page

class Insights extends StatelessWidget {
  const Insights({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('insights'),
      ),
      body: const Center(
        child: Text('Insights Page Content'),
      ),
    );
  }
}
