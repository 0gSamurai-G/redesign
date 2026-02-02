
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/splash.dart';

void main() {
  runApp(const PlayZApp());
}

class PlayZApp extends StatelessWidget {
  const PlayZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayZ',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
      //  home: const TurfDetailScreen(),
    );
  }
}

