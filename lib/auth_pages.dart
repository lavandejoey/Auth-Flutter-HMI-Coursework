import 'package:flutter/material.dart';
import 'menu_buttons.dart';
import 'database.dart';
import 'user.dart';
import 'user_profile.dart';
import 'utils.dart';

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
              "Sign Up",
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      onPressed: () async {
                        String username = usernameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;
                        String passwordConfirm = passwordConfirmController.text;
                        if (password != passwordConfirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Password and Confirmed do not match.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Show the SnackBar with CircularProgressIndicator when initiating the login process
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(children: [
                              CircularProgressIndicator(),
                              Text("Signing up...")
                            ]),
                          ),
                        );
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

  void authAndLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // Show the SnackBar with CircularProgressIndicator when initiating the login process
    loadingSnack(context: context, noteText: "Logging in...");
    User? authUser =
        await widget.userDb.authUser(username: username, password: password);

    // After getting the authentication result, hide the SnackBar and proceed accordingly
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (authUser != null) {
      // navigate to profile page
      Navigator.pop(context); // This pops the login page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserProfilePage(userDb: widget.userDb, user: authUser),
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
          content: Text('Login failed. Invalid credentials.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      onPressed: () => authAndLogin(),
                      child: const Text('Log In'),
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

void showForgetPasswordDialog(BuildContext context) {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Forget Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Process forget password functionality
                // Retrieve the username and email entered
                String username = userController.text;
                String email = emailController.text;

                // Implement your forget password logic here...
                // This might involve sending an email with a password reset link, for instance

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    },
  );
}
