import 'package:flutter/material.dart';

void showSuccessSnackBar({
  required BuildContext context,
  required String message,
  required VoidCallback onContinue,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: "Continuer",
        textColor: Colors.white,
        onPressed: onContinue,
      ),
    ),
  );
}
