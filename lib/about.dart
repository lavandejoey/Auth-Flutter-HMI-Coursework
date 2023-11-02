import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_svg/flutter_svg.dart';

// icon at https://joshuaziyiliu.com/static/img/logo-pic.png
final iconImage =
    Image.asset("assets/images/logo-pic-bg.png", width: 40, height: 40);
final applicationLegalese =
    "\u{00A9} 2023${(DateTime.now().year == 2023) ? "" : " - ${DateTime.now().year}"} Joshua Ziyi Liu. All rights reserved.";
const describeText = Text(
    "This is a coursework for the Human Machine Interaction course at ECUST.");
final githubHyperLink = GestureDetector(
  onTap: () {
    launchUrl("https://github.com/lavandejoey/Auth-Flutter-HMI-Coursework.git"
        as Uri);
  },
  child: const Text(
    "GitHub Repository",
    style: TextStyle(
      color: infoColor,
      decoration: TextDecoration.underline,
    ),
  ),
);

void helpShowAboutDialog({required BuildContext context}) {
  showAboutDialog(
    context: context,
    applicationName: "Authentication Flutter\t (HMI Coursework)",
    applicationVersion: "1.0.0",
    applicationIcon: iconImage,
    applicationLegalese: applicationLegalese,
    children: [
      const SizedBox(height: 10),
      describeText,
      const SizedBox(height: 10),
      Row(
        children: [
          const Text("Source code available at "),
          githubHyperLink,
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}
