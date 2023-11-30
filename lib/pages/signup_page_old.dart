import 'package:flutter/material.dart';
import 'package:hmi/pages/login_page_old.dart';
import 'package:hmi/pages/user_profile_page.dart';
import 'package:hmi/utils.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/menu_buttons.dart';
import 'package:hmi/utils/params.dart';
import 'package:hmi/utils/theme.dart';
import 'package:hmi/utils/user_model.dart';
import 'package:hmi/utils/validation.dart';

class OldSignUpPage extends StatefulWidget {
  final String title = "Create an Account";
  final UserDb userDb;

  const OldSignUpPage({super.key, required this.userDb});

  @override
  State<OldSignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<OldSignUpPage> {
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();

    usernameEdited = false;
    isUsernameValid = true;
    isForbiddenUsername = false;
    emailEdited = false;
    isEmailValid = true;
    passwordEdited = false;
    isPasswordValid = true;
    passwordConfirmEdited = false;
    isPasswordMatch = true;
    isFormValid = false;
  }

  void validateUsername() {
    bool isLegalName = isNotForbiddenCriteria(usernameController.text);
    setState(() {
      usernameEdited = true;
      isForbiddenUsername = !isLegalName;
      // 4-32 characters
      isUsernameValid = isLegalName &&
          usernameController.text.length >= 4 &&
          usernameController.text.length <= 32;
    });
  }

  void validateEmail() {
    String emailPattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regExp = RegExp(emailPattern);
    setState(() {
      emailEdited = true;
      isEmailValid = regExp.hasMatch(emailController.text);
    });
  }

  void validatePassword() {
    setState(() {
      passwordEdited = true;
      // 6-64 characters
      isPasswordValid = passwordController.text.length >= 6 &&
          passwordController.text.length <= 64;
    });
  }

  void validatePasswordMatch() {
    setState(() {
      passwordConfirmEdited = true;
      isPasswordMatch =
          passwordController.text == passwordConfirmController.text;
    });
  }

  void validateForm() {
    validateUsername();
    validateEmail();
    validatePassword();
    validatePasswordMatch();
    isFormValid =
        isUsernameValid && isEmailValid && isPasswordValid && isPasswordMatch;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Add big title
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
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
                            labelText: "Username",
                          ),
                          onChanged: (text) => validateUsername(),
                        ),
                        Text(
                          isUsernameValid
                              ? ""
                              : isForbiddenUsername
                                  ? "Username is forbidden."
                                  : "Username must be 4-32 characters.",
                          style: const TextStyle(
                            color: dangerColor,
                          ),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                          ),
                          onChanged: (text) => validateEmail(),
                        ),
                        Text(
                          isEmailValid ? "" : "Email is invalid.",
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
                          obscureText: true, // to hide the password
                          onChanged: (text) => validatePassword(),
                        ),
                        Text(
                          isPasswordValid
                              ? ""
                              : "Password must be 6-64 characters.",
                          style: const TextStyle(
                            color: dangerColor,
                          ),
                        ),
                        TextField(
                          controller: passwordConfirmController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confirm Password",
                          ),
                          obscureText: true, // to hide the password
                          onChanged: (text) => validatePasswordMatch(),
                        ),
                        Text(
                          isPasswordMatch
                              ? ""
                              : "Password and Confirm Password do not match.",
                          style: const TextStyle(
                            color: dangerColor,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                          ),
                          onPressed: () async {
                            String username = usernameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            // Local validation
                            validateForm();
                            if (!isFormValid) {
                              return;
                            }

                            // Show the SnackBar with CircularProgressIndicator when initiating the login process
                            loadingSnack(
                                context: context, noteText: "Signing up...");
                            User? newUser = await widget.userDb.insertUser(User(
                                username: username,
                                password: password,
                                email: email,
                                createdAt: "",
                                updatedAt: ""));

                            // After getting the authentication result, hide the SnackBar and proceed accordingly
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            if (newUser != null) {
                              // This pops the signup page
                              Navigator.pop(context);
                              // navigate to profile page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                      userDb: widget.userDb, user: newUser),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Signed up successful!")),
                              );
                              // Pop the current screen (assuming it"s the signup page) and navigate back to the login page
                              Navigator.pop(
                                  context); // This pops the signup page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage(userDb: widget.userDb)),
                              );
                            } else {
                              // Failed login
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Sign up failed. User already exist."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text("Sign Up"),
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
                    Expanded(child: logInButton(context, widget.userDb)),
                    Expanded(child: recoverPasswordButton(context)),
                    Expanded(child: aboutButton(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
