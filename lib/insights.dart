// Placeholder Alerts Page
import 'package:flutter/material.dart';

class HotTips extends StatelessWidget {
  const HotTips({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hottips'),
      ),
      body: const Center(
        child: Text('tips based on prediction'),
      ),
    );
  }
}
