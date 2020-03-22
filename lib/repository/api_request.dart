import 'dart:convert';

import 'package:chat_app/models/Conversation.dart';
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

      await storage.write(key: "username", value: body['user']['username']);
      await storage.write(key: "id", value: body['user']['id']);
      await storage.write(key: "token", value: body['token']);

      onSuccess();
      return response;
    } else {
      onFailure();
      print("FAIL");
      return response;
    }
  }

  static Future<String> doRegister(String username, String password,
      String repassword, Function onSuccess, Function onFailure) async {
    final http.Response response = await http.post(
      baseUrl + '/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'repassword': repassword
      }),
    );
    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      onSuccess();
      print(response.body);
      return "";
    } else {
      print(response.body);
      onFailure();
      print("FAIL");
      return body['message'].toString();
    }
  }

  static Future<List<Conversation>> getConversation() async {
    var storage = FlutterSecureStorage();
    var id = await storage.read(key: 'id');
    var token = await storage.read(key: 'token');

    final http.Response response = await http
        .get(baseUrl + '/conversation-list?id=$id', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<Conversation> cvs = (json.decode(response.body)['list'] as List)
          .map((i) => Conversation.fromJson(i))
          .toList();

      return cvs;
    } else {
      print(response.body);
    }
  }

  static Future<String> getMyUserName() {
    var storage = FlutterSecureStorage();
    return storage.read(key: 'username');
  }
}
