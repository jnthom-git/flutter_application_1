import 'package:flutter/material.dart';
import 'pages/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}