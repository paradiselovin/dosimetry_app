import 'package:flutter/material.dart';

void showSuccessSnackBar({
  required BuildContext context,
  required String message,
  VoidCallback? onContinue,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: onContinue == null
          ? null
          : SnackBarAction(
              label: "Continuer",
              textColor: Colors.white,
              onPressed: onContinue,
            ),
    ),
  );
}
