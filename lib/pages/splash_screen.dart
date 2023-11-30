import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmi/pages/login_page.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  final UserDb userDb = UserDb();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(userDb: widget.userDb),
          // builder: (context) => LoginPage(userDb: widget.userDb),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(context, 160, 160),
            const SizedBox(
              height: 25,
            ),
            richText(30),
          ],
        ),
      ),
    );
  }

  Widget logo(BuildContext context, double height_, double width_) {
    return SvgPicture.asset(
      "assets/images/logo-pic.svg",
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: secondaryColor,
          letterSpacing: 3,
          height: 1.03,
        ),
        children: [
          TextSpan(
            text: "Joshua's ",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextSpan(
            text: "Auth \nFlutter",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " App",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
