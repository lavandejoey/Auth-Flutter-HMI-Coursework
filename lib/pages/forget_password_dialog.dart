import "package:flutter/material.dart";

void showForgetPasswordDialog(BuildContext context) {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Forget Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
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
              child: const Text("Submit"),
            ),
          ],
        ),
      );
    },
  );
}
