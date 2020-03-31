import 'package:commons/commons.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog {
  static void showConfirmation(
      context, msg, Function neutral, Function positive) {
    confirmationDialog(
      context,
      msg,
      neutralText: "Cancel",
      neutralAction: neutral,
      positiveText: "Yes",
      positiveAction: positive,
    );
  }

  static void hideConfirmDialog(BuildContext context) {
    Navigator.of(context).pop(ConfirmationDialog);
  }
}
