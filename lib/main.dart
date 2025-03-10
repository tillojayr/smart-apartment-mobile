import 'package:flutter/material.dart';
import 'package:tes2_project/pages/home_page.dart';
import 'package:tes2_project/pages/ip_input_page.dart';
import 'pages/login_page.dart';
import 'dart:core';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart-Watt',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const IpInputPage(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  Future<void> _initializeApp() async {
    // Perform any app initialization tasks here
    await Future.delayed(Duration(seconds: 3)); // Simulating initialization delay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the initialization, show the logo
            return Center(
              child: SizedBox(
                width: 150, // Adjust the width as needed
                height: 150, // Adjust the height as needed
                child: Image.asset('images/logo.png'), // Replace with your logo image
              ),
            );
          } else {
            // Once the initialization is done, navigate to the login page or main content
            return LoginPage();
          }
        },
      ),
    );
  }
}

