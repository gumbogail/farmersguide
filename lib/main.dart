import 'package:farmersguide/home.dart';
import 'package:flutter/material.dart';
import 'droughtresuts.dart'; // Prediction page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Prediction App',
      theme: ThemeData(
        brightness: Brightness.light, // Light theme for the app
        primaryColor: Colors.black, // Primary color (used in app bars, etc.)
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // White background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // White background for the AppBar
          foregroundColor: Colors.black, // Black text on the AppBar
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.black, // Black as the primary color
          onPrimary: Colors.white, // White text/icons on primary color
          secondary: Colors.black, // Black as the accent color
          background: Color.fromARGB(255, 255, 255, 255), // White background
          surface: Color.fromARGB(
              255, 255, 255, 255), // White surface (cards, buttons, etc.)
          onSurface: Colors.black, // Black text/icons on surface color
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0)), // Black body text color
        ),
        useMaterial3: true,
      ),
      home: const HomePage(
        latitude: 0.0,
        longitude: 0.0,
      ),
    );
  }
}
