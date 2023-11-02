import 'package:flutter/material.dart';
import 'auth_pages.dart';
import 'database.dart';
import 'user.dart';

IconButton settingButton(BuildContext context, UserDb userDb) {
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
                    // Handle edit functionality TODO
                  }),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    // Handle logout functionality TODO
                  }),
              ListTile(
                  // Always show About option
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    // Handle about functionality TODO
                  })
            ],
          );
        },
      );
    },
  );
}

// show userDb.muserCurrentUser profile if userDb.mbLoggedIn is true else go to loginpage
IconButton profileButton(BuildContext context, UserDb userDb) {
  return IconButton(
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
    icon: const Icon(Icons.account_circle),
  );
}
