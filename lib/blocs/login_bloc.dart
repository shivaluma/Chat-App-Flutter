import 'dart:async';

import 'package:chat_app/validators/validation.dart';

class LoginBloc {
  StreamController _usernameController = new StreamController();
  StreamController _passwordController = new StreamController();

  Stream get usernameStream => _usernameController.stream;
  Stream get passwordStream => _passwordController.stream;

  bool isValidInfo(String username, String password) {
    if (!Validations.isValid(username)) {
      _usernameController.sink.addError("Username cannot be empty.");
      return false;
    }
    _usernameController.sink.add('OK');
    if (!Validations.isValid(password)) {
      _passwordController.sink.addError("Password cannot be empty.");
      return false;
    }
    _passwordController.sink.add('OK');
    return true;
  }

  void dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}
