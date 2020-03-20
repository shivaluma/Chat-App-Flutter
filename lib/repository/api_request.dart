import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiRequest {
  static final String baseUrl = "https://artful-wind-271202.appspot.com/api";

  static Future<http.Response> doLogin(String username, String password) async {
    final http.Response response = await http.post(
      baseUrl + '/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }
}
