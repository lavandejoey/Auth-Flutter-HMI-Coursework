import 'package:flutter/material.dart';
import 'menu_buttons.dart';
import 'database.dart';
import 'user.dart';

class SignUpPage extends StatefulWidget {
  final String title = "Sign Up";
  final UserDb userDb;

  const SignUpPage({super.key, required this.userDb});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Home button
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Jump to WelcomePage
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true, // to hide the password
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordConfirmController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                        ),
                        obscureText: true, // to hide the password
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String username = usernameController.text;
                          String email = emailController.text;
                          String password = passwordController.text;
                          String passwordConfirm =
                              passwordConfirmController.text;
                          if (password != passwordConfirm) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Password and Confirmed do not match.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Show the SnackBar with CircularProgressIndicator when initiating the login process
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text("Signing up..."),
                                ],
                              ),
                            ),
                          );
                          User? newUser = await widget.userDb.insertUser(
                            User(
                              username: username,
                              password: password,
                              email: email,
                              createdAt: "",
                              updatedAt: "",
                            ),
                          );

                          // After getting the authentication result, hide the SnackBar and proceed accordingly
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          if (newUser != null) {
                            // navigate to profile page
                            Navigator.pop(context); // This pops the signup page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfilePage(
                                    userDb: UserDb(),
                                    user:
                                        newUser // Pass the retrieved user object to UserProfilePage
                                    ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Signed up successful!")),
                            );
                            // Pop the current screen (assuming it's the signup page) and navigate back to the login page
                            Navigator.pop(context); // This pops the signup page
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
                                content:
                                    Text('Sign up failed. User already exist.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title = "Log In";
  final UserDb userDb;

  const LoginPage({super.key, required this.userDb});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Home button
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Jump to WelcomePage
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true, // to hide the password
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String username = usernameController.text;
                          String password = passwordController.text;

                          // Show the SnackBar with CircularProgressIndicator when initiating the login process
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text("Logging in..."),
                                ],
                              ),
                            ),
                          );
                          User? authUser = await widget.userDb
                              .authUser(username, null, password);

                          // After getting the authentication result, hide the SnackBar and proceed accordingly
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          if (authUser != null) {
                            // navigate to profile page
                            Navigator.pop(context); // This pops the login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfilePage(
                                    userDb: UserDb(),
                                    user:
                                        authUser // Pass the retrieved user object to UserProfilePage
                                    ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login successful!'),
                              ),
                            );
                          } else {
                            // Failed login
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Login failed. Invalid credentials.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Log In'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final User user; // User object to access user details
  final UserDb userDb;

  const UserProfilePage({
    super.key,
    required this.userDb,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          settingButton(context, userDb),
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

              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ChangePasswordPage(user: user)),
              //     );
              //   },
              //   child: const Text('Change Password'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
