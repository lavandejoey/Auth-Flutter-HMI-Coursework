import "package:flutter/material.dart";
import "database.dart";
import "menu_buttons.dart";
import "auth_pages.dart";

void main() => runApp(FlutterHMICoursework());

// Define the colors
const Color primaryColor = Color(0xFFa55d51);
const Color secondaryColor = Color(0xFF1f3b54);
const Color tertiaryColor = Color(0xffd1d4c8);
const Color successColor = Color(0xFF146654);
const Color infoColor = Color(0xFF3c7699);
const Color warningColor = Color(0xFFfed300);
const Color dangerColor = Color(0xFF983928);
const Color lightColor = Color(0xFFF2F2F2);
const Color darkColor = Color(0xFF000000);

// Define your theme
final ThemeData flutterHMIColour = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    error: dangerColor,
    background: tertiaryColor,
  ),
  useMaterial3: true,
  // Default app bar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
    ),
  ),
  // Default snackbar theme
  snackBarTheme: const SnackBarThemeData(
    actionTextColor: Colors.white,
    contentTextStyle: TextStyle(color: Colors.white),
    insetPadding: EdgeInsets.all(20.0),
    // set indocator color
    behavior: SnackBarBehavior.floating,
  ),
  // Default input decoration theme
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  ),
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
      theme: flutterHMIColour,
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
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Shantell",
              fontWeight: FontWeight.bold,
            ),
          ),
          // Transparent background
          backgroundColor: Colors.transparent,
          // Profile button account_circle at the end
          actions: <Widget>[
            profileButton(context, userDb),
          ]),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 20),
          FutureBuilder<int>(
            future: userDb.getUserCount(),
            // Assuming there"s a method to get the user count
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}",
                    style: const TextStyle(
                        color: dangerColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20));
              } else {
                final userCount = snapshot.data ?? "-";
                return Text("Total Users: $userCount",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20));
              }
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text("Sign Up"),
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
            child: const Text("Log In"),
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
