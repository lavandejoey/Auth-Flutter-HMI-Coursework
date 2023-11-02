import 'package:flutter/material.dart';

void loadingSnack({required BuildContext context, required String noteText}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const SizedBox(width: 10),
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Text(noteText),
        ],
      ),
    ),
  );
}
