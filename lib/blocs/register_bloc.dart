import 'dart:async';

import 'package:chat_app/repository/api_request.dart';
import 'package:chat_app/validators/validation.dart';

class RegisterBloc {
  StreamController _usernameController = new StreamController();
  StreamController _passwordController = new StreamController();
  StreamController _passwordAgainController = new StreamController();

  Stream get usernameStream => _usernameController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get passwordAgainStream => _passwordAgainController.stream;

  bool isValidInfo(String username, String password, String password2) {
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

    if (!Validations.isValid(password2)) {
      _passwordAgainController.sink
          .addError("Password confirm cannot be empty.");
      return false;
    }
    _passwordAgainController.sink.add('OK');

    if (password != password2) {
      _passwordAgainController.sink.addError("Password do not match.");
      _passwordController.sink.addError("Password do not match.");
      return false;
    }

    _passwordController.sink.add('OK');
    _passwordAgainController.sink.add('OK');

    return true;
  }

  void doRegister(String username, String password, String repassword,
      Function onSuccess, Function onFailure) async {
    String err = await ApiRequest.doRegister(
        username, password, repassword, onSuccess, onFailure);
    if (err.length > 0) {
      _usernameController.sink.addError(err);
    }
  }

  void dispose() {
    _usernameController.close();
    _passwordController.close();
    _passwordAgainController.close();
  }
}
