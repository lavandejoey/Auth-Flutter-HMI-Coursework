import 'package:flutter/material.dart';

import 'database.dart';
import 'menu_buttons.dart';
import 'user.dart';

class UserProfilePage extends StatelessWidget {
  final User user;
  final UserDb userDb;

  const UserProfilePage({
    super.key,
    required this.userDb,
    required this.user,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        // Transparent background
        backgroundColor: Colors.transparent,
        actions: [
          settingButton(context: context, userDb: userDb, user: user),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                "User Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Display user details
              Text('Name: ${user.username}'),
              const SizedBox(height: 20),
              Text('ID: ${user.uid}'),
              const SizedBox(height: 20),
              Text('E-mail: ${user.email}'),
              const SizedBox(height: 20),
              Text('Sign-up Date: ${user.createdAt}'),
              const SizedBox(height: 20),
              Text('Last Login: ${user.updatedAt}'),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
