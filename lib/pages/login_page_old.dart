import 'package:flutter/material.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/menu_buttons.dart';
import 'package:hmi/pages/user_profile_page.dart';
import 'package:hmi/utils.dart';
import 'package:hmi/utils/params.dart';
import 'package:hmi/utils/theme.dart';

class LoginPage extends StatefulWidget {
  final String title = "Log In";
  final UserDb userDb;

  const LoginPage({super.key, required this.userDb});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isUserExists;
  late bool logInByName;
  late bool logInByEmail;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    isUsernameValid = true;
    usernameEdited = false;
    isUserExists = false;
    isPasswordValid = true;
    passwordEdited = false;
    isFormValid = false;
    logInByName = true;
    logInByEmail = false;
  }

  void validateUsername() async {
    String emailPattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp emailRegExp = RegExp(emailPattern, caseSensitive: false);
    if (emailRegExp.hasMatch(usernameController.text)) {
      // email
      widget.userDb
          .isUserExists(email: usernameController.text)
          .then((value) => setState(() {
                usernameEdited = true;
                isUserExists = value;
                logInByEmail = true;
                logInByName = false;
              }));
    } else {
      // username
      widget.userDb
          .isUserExists(username: usernameController.text)
          .then((value) => setState(() {
                usernameEdited = true;
                isUserExists = value;
                logInByEmail = false;
                logInByName = true;
              }));
    }
    isUsernameValid = usernameController.text.isNotEmpty && isUserExists;
  }

  void validatePassword() {
    setState(() {
      passwordEdited = true;
      isPasswordValid = passwordController.text.isNotEmpty;
    });
  }

  void validateForm() {
    validateUsername();
    validatePassword();
    isFormValid = isUsernameValid && isPasswordValid;
  }

  void authAndLogin() async {
    validateForm();
    if (!isFormValid) {
      return;
    }

    String username = usernameController.text;
    String password = passwordController.text;

    // Show the SnackBar with CircularProgressIndicator when initiating the login process
    loadingSnack(context: context, noteText: "Logging in...");
    widget.userDb
        .authUser(username: username, password: password)
        .then((authUser) => {
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              if (authUser != null)
                {
                  // navigate to profile page
                  Navigator.pop(context), // This pops the login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                          userDb: widget.userDb, user: authUser),
                    ),
                  ),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login successful!"),
                    ),
                  ),
                }
              else
                {
                  // Failed login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login failed. Invalid credentials."),
                      backgroundColor: Colors.red,
                    ),
                  ),
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: Text(widget.title),
        // Transparent background
        backgroundColor: Colors.transparent,
        leading: popBackButton(context),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Add big title
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              "Log In",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username or Email",
                      ),
                      onChanged: (text) => validateUsername(),
                    ),
                    Text(
                      isUsernameValid
                          ? ""
                          : logInByName
                              ? "Username does not exist."
                              : logInByEmail
                                  ? "Email does not exist."
                                  : "Username or Email does not exist.",
                      style: const TextStyle(
                        color: dangerColor,
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      onChanged: (text) => validatePassword(),
                      obscureText: true, // to hide the password
                    ),
                    Text(
                      isPasswordValid ? "" : "Password cannot be empty.",
                      style: const TextStyle(
                        color: dangerColor,
                      ),
                    ),
                    const SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => authAndLogin(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Log In"),
                              SizedBox(width: 8),
                              // Adjust the space between the button and the icon
                              Icon(
                                Icons.login,
                                // Your login icon (replace with the desired icon)
                                size: 24, // Set the size of the icon as needed
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 0.0, bottom: 80.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: signUpButton(context, widget.userDb)),
                Expanded(child: recoverPasswordButton(context)),
                Expanded(child: aboutButton(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
