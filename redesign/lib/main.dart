import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/splash.dart';
import 'package:redesign/controller/maps_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  // Initialize UserProfileController globally
  Get.put(UserProfileController());
  Get.put(MapsController(), permanent: true);

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
