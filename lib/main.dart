import 'package:flutter/material.dart';
import 'database.dart';
import 'menu_buttons.dart';
import 'auth_pages.dart';

void main() => runApp(FlutterHMICoursework());

// Define the colors
const Color primaryColor = Color(0xFFa55d51);
const Color secondaryColor = Color(0xFF1f3b54);
const Color tertiaryColor = Color(0xFFbdd0ca);
const Color successColor = Color(0xFF146654);
const Color infoColor = Color(0xFF3c7699);
const Color warningColor = Color(0xFFfed300);
const Color dangerColor = Color(0xFF983928);
const Color lightColor = Color(0xFFF2F2F2);
const Color darkColor = Color(0xFF000000);

// Define your theme
final ThemeData HMIColour = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    error: dangerColor,
    background: tertiaryColor,
  ),
  // useMaterial3: true,
);

class FlutterHMICoursework extends StatelessWidget {
  FlutterHMICoursework({super.key});

  final UserDb userDb = UserDb();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(userDb: userDb),
      title: "HMI Coursework Authentication",
      theme: HMIColour,
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String title = "Welcome to Joshua's App!";
  final UserDb userDb;

  const WelcomePage({super.key, required this.userDb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.primary,
          // Profile button account_circle at the end
          actions: <Widget>[
            profileButton(context, userDb),
          ]),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 20),
          FutureBuilder<int>(
            future: userDb.getUserCount(),
            // Assuming there's a method to get the user count
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userCount = snapshot.data ?? "-";
                return Text('Total Users: $userCount');
              }
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Sign Up'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpPage(userDb: userDb)),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Log In'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(userDb: userDb)),
              );
            },
          ),
        ]),
      ),
    );
  }
}
