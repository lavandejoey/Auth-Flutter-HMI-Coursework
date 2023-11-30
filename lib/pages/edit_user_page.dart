import "package:flutter/material.dart";
import 'package:hmi/utils.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/menu_buttons.dart';
import 'package:hmi/utils/user_model.dart';

import 'user_profile_page.dart';

class EditUserPage extends StatefulWidget {
  final UserDb userDb;
  final User user;
  final bool changePassword;

  const EditUserPage(
      {super.key,
      required this.userDb,
      required this.user,
      required this.changePassword});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController uidController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController newPasswordController = TextEditingController();
  late TextEditingController confirmNewPasswordController =
      TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  bool isUpdateDisabled = false;

  @override
  void initState() {
    super.initState();
    uidController = TextEditingController(text: widget.user.uid);
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    newPasswordController = TextEditingController(); // only for changePassword
    confirmNewPasswordController =
        TextEditingController(); // only for changePassword
    passwordController = TextEditingController();
    // Set initial state for isUpdateDisabled
    updateIsUpdateDisabled();
  }

  void updateIsUpdateDisabled() {
    setState(() {
      widget.changePassword
          ? isUpdateDisabled = newPasswordController.text.isEmpty ||
              confirmNewPasswordController.text.isEmpty ||
              newPasswordController.text != confirmNewPasswordController.text
          : isUpdateDisabled = usernameController.text.isEmpty ||
              emailController.text.isEmpty ||
              passwordController.text.isEmpty ||
              (usernameController.text == widget.user.username &&
                  emailController.text == widget.user.email &&
                  phoneController.text == widget.user.phone);
    });
  }

  @override
  void dispose() {
    uidController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void authorizeAndUpdate(BuildContext context) async {
    String uid = uidController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;
    String password = passwordController.text;

    if (widget.changePassword) {
      if (newPassword != confirmNewPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("New password and confirm new password do not match."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    loadingSnack(context: context, noteText: "Authorizing...");
    try {
      final authedUser = await widget.userDb.authUser(
        uid: widget.user.uid,
        username: widget.user.username,
        email: widget.user.email,
        password: password,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (authedUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Authorization failed. Invalid credentials."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      loadingSnack(context: context, noteText: "Updating...");
      password = widget.changePassword ? newPassword : password;
      final updatedUser = await widget.userDb.updateUser(User(
        uid: uid,
        username: username,
        email: email,
        phone: phone,
        password: password,
        createdAt: "",
        updatedAt: "",
      ));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (updatedUser != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserProfilePage(userDb: widget.userDb, user: updatedUser),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Updated successfully!")),
        );
        Navigator.pop(context); // This pops the signup page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Update failed. Invalid credentials."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Process failed: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User"),
        backgroundColor: Colors.transparent,
        leading: popBackButton(context),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, bottom: 0.0, left: 60.0, right: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: uidController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "UID",
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                      ),
                      onChanged: (value) {
                        updateIsUpdateDisabled();
                      },
                      enabled: widget.changePassword ? false : true,
                    ),
                    const SizedBox(height: 20),
                    if (!widget.changePassword) ...[
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        onChanged: (value) {
                          updateIsUpdateDisabled();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone (Optional)",
                        ),
                        onChanged: (value) {
                          updateIsUpdateDisabled();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      obscureText: true, // to hide the password
                      onChanged: (value) {
                        updateIsUpdateDisabled();
                      },
                    ),
                    const SizedBox(height: 20),
                    if (widget.changePassword) ...[
                      TextField(
                        controller: newPasswordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "New Password",
                        ),
                        obscureText: true, // to hide the password
                        onChanged: (value) {
                          updateIsUpdateDisabled();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: confirmNewPasswordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm New Password",
                        ),
                        obscureText: true, // to hide the password
                        onChanged: (value) {
                          updateIsUpdateDisabled();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    ElevatedButton(
                      onPressed: isUpdateDisabled
                          ? null
                          : () => authorizeAndUpdate(context),
                      child: const Text("Update"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
