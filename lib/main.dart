import "package:flutter/material.dart";
import 'package:hmi/pages/splash_screen.dart';
import 'package:hmi/utils/theme.dart';

void main() => runApp(const FlutterHMICoursework());

class FlutterHMICoursework extends StatelessWidget {
  const FlutterHMICoursework({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: WelcomePage(userDb: userDb),
      home: SplashScreen(),
      title: "HMI Coursework Authentication",
      theme: flutterHMIColour,
    );
  }
}
