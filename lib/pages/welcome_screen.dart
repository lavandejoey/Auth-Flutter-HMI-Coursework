// package:hmi/page/welcome_screen.dart
import "package:flutter/material.dart";
import "package:hmi/pages/login_page_old.dart";
import "package:hmi/pages/signup_page.dart";
import "package:hmi/pages/signup_page_old.dart";
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/menu_buttons.dart';
import "package:hmi/utils/theme.dart";
import "package:url_launcher/url_launcher.dart";

class WelcomePage extends StatefulWidget {
  final String title = "Welcome to Joshua's App!";
  final UserDb userDb;

  const WelcomePage({super.key, required this.userDb});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late String strUserCount;

  @override
  void initState() {
    super.initState();
    strUserCount = "-";
    _loadUserCount();
  }

  Future<void> _loadUserCount() async {
    final userCount = await widget.userDb.getUserCount();
    setState(() {
      strUserCount = userCount.toString();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      strUserCount = "-";
    });
    await _loadUserCount();
    // Simulate loading of data for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "Shantell",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          profileButton(context, widget.userDb),
        ],
      ),
      body: RefreshIndicator(
        displacement: 10,
        edgeOffset: 5,
        onRefresh: _refreshData,
        color: primaryColor,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 80),
                Text(
                  "Total Users: $strUserCount",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        minimumSize: const Size(100, 40),
                      ),
                      child: const Text("Sign Up"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage(userDb: widget.userDb),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        minimumSize: const Size(100, 40),
                      ),
                      child: const Text("Log In"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(userDb: widget.userDb),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse("https://joshuaziyiliu.com"));
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Supported by ",
                                  style: TextStyle(color: infoColor),
                                ),
                                Text(
                                  "JoshuaZiyiLiu.com",
                                  style: TextStyle(
                                      color: infoColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
