import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  static final String baseUrl = "https://artful-wind-271202.appspot.com/api";

  static Future<http.Response> doLogin(String username, String password,
      Function onSuccess, Function onFailure) async {
    final http.Response response = await http.post(
      baseUrl + '/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      var storage = FlutterSecureStorage();
      var body = jsonDecode(response.body);
      storage.write(key: "username", value: body['user']['username']);
      storage.write(key: "id", value: body['user']['id']);
      storage.write(key: "token", value: body['token']);
      onSuccess();
      return response;
    } else {
      onFailure();
      print("FAIL");
      return response;
    }
  }
}
