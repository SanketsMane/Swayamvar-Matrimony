import 'package:flutter/material.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('DEBUG SCREEN'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'SUCCESS!\n\nIf you see this screen, the navigation logic is CORRECT. The problem is inside your Account screen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
