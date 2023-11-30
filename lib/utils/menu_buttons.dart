import 'package:flutter/material.dart';
import 'package:hmi/pages/about_dialog.dart';
import 'package:hmi/pages/edit_user_page.dart';
import 'package:hmi/pages/forget_password_dialog.dart';
import 'package:hmi/pages/login_page.dart';
import 'package:hmi/pages/signup_page.dart';
import 'package:hmi/pages/user_profile_page.dart';

import 'database.dart';
import 'user_model.dart';

IconButton popBackButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back),
    // pop one page
    onPressed: () => Navigator.pop(context),
  );
}


// show userDb.muserCurrentUser profile if userDb.mbLoggedIn is true else go to login page
IconButton profileButton(BuildContext context, UserDb userDb) {
  return IconButton(
    icon: const Icon(Icons.account_circle),
    onPressed: () {
      userDb.mbLoggedIn
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                      userDb: userDb, user: userDb.muserCurrentUser as User)))
          : // Navigate to the login page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(userDb: userDb)));
    },
  );
}

// Log in button
GestureDetector logInButton(BuildContext context, UserDb userDb) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(userDb: userDb)),
      );
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          padding: const EdgeInsets.all(15.0),
          child: const Icon(Icons.login),
        ),
        // const SizedBox(height: 15),
        // const Text("Log In"),
      ],
    ),
  );
}

// Sign up button
GestureDetector signUpButton(BuildContext context, UserDb userDb) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage(userDb: userDb)),
      );
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          padding: const EdgeInsets.all(15.0),
          child: const Icon(Icons.app_registration),
        ),
        // const SizedBox(height: 15),
        // const Text("Sign Up"),
      ],
    ),
  );
}

// recover password button
GestureDetector recoverPasswordButton(BuildContext context) {
  return GestureDetector(
    onTap: () => showForgetPasswordDialog(context),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          padding: const EdgeInsets.all(15.0),
          child: const Icon(Icons.search),
        ),
        // const SizedBox(height: 15),
        // const Text("Forget Password"),
      ],
    ),
  );
}

// About button to show about dialog
GestureDetector aboutButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      helpShowAboutDialog(context: context);
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          padding: const EdgeInsets.all(15.0),
          child: const Icon(Icons.info),
        ),
        // const SizedBox(height: 15),
        // const Text("About"),
      ],
    ),
  );
}
