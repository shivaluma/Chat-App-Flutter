import 'package:commons/commons.dart';
import 'package:flutter/material.dart';

class WarningDialog {
  static void showWarning(context, msg, Function neutral) {
    warningDialog(
      context,
      msg,
      neutralText: "OK",
      neutralAction: neutral,
    );
  }

  static void hideConfirmDialog(BuildContext context) {
    Navigator.of(context).pop(WarningDialog);
  }
}
