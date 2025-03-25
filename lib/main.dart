import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSIM Checker',
      home: const SafeArea(
        child: Scaffold(
          body: Center(
            child: Text(
              'eSIM Checker',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
} 