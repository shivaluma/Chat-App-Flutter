import 'dart:convert';

import 'package:chat_app/models/Conversation.dart';
import 'package:chat_app/models/Message.dart';
import 'package:chat_app/models/MessageResponse.dart';
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

  static Future<List<Conversation>> getConversation(Function failed) async {
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
      failed();
      return null;
    }
  }

  static Future<MessageResponse> getMessages(String cvsId,
      [int last = -1]) async {
    var storage = FlutterSecureStorage();
    var id = await storage.read(key: 'id');
    var token = await storage.read(key: 'token');

    final http.Response response = await http.get(
        baseUrl + '/get-messages?cid=$cvsId&last=$last',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      List<Message> cvs = (json.decode(response.body)['messageList'] as List)
          .map((i) => Message.fromJson(i))
          .toList();

      return MessageResponse(
          listMsg: cvs.reversed.toList(),
          newLast: json.decode(response.body)['newLast']);
    } else {
      return null;
    }
  }

  static Future<Message> sendMessage(String cid, String content) async {
    var storage = FlutterSecureStorage();
    var uid = await storage.read(key: 'id');
    var username = await storage.read(key: 'username');
    var token = await storage.read(key: 'token');
    final http.Response response = await http.post(
      baseUrl + '/send-message',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'cid': cid,
        'uid': uid,
        'content': content,
        'username': username
      }),
    );

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body)['newMessage']);
    } else {
      return null;
    }
  }

  static Future<String> getMyUserName() {
    var storage = FlutterSecureStorage();
    return storage.read(key: 'username');
  }

  static Future<String> getMyId() {
    var storage = FlutterSecureStorage();
    return storage.read(key: 'id');
  }

  static Future<String> getToken() {
    var storage = FlutterSecureStorage();
    return storage.read(key: 'token');
  }

  static void doLogout() async {
    var storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
