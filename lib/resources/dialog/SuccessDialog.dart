import 'package:commons/commons.dart';
import 'package:flutter/material.dart';

class SuccessDialog {
  static void showSuccessDialog(context, msg, Function neutral) {
    successDialog(
      context,
      msg,
      neutralText: "Back to Login",
      neutralAction: neutral,
    );
  }

  static void hideSuccessDialog(BuildContext context) {
    Navigator.of(context).pop(SuccessDialog);
  }
}
