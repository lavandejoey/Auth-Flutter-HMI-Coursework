import 'package:flutter/material.dart';
import 'package:hmi/pages/about_dialog.dart';
import 'package:hmi/pages/edit_user_page.dart';
import 'package:hmi/pages/login_page.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/user_model.dart';

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
              // Phone number
              Text(user.phone != null
                  ? 'Phone: ${user.phone}'
                  : 'Phone: Not set'),
              const SizedBox(height: 20),
              const Text('Admin: No'),
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

  IconButton settingButton(
      {required BuildContext context,
      required UserDb userDb,
      required User user}) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit User'),
                    onTap: () {
                      // Close the bottom sheet of menu
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserPage(
                                  userDb: userDb,
                                  user: userDb.muserCurrentUser as User,
                                  changePassword: false)));
                    }),
                ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Change Password"),
                    onTap: () {
                      // Close the bottom sheet of menu
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserPage(
                                  userDb: userDb,
                                  user: userDb.muserCurrentUser as User,
                                  changePassword: true)));
                    }),
                ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      userDb.logOut();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(userDb: userDb),
                        ),
                      );
                    }),
                ListTile(
                    // Always show About option
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {
                      helpShowAboutDialog(context: context);
                    })
              ],
            );
          },
        );
      },
    );
  }
}
