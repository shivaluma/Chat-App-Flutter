import 'package:chat_app/models/User.dart';
import 'package:flutter/material.dart';

class Message {
  final User sender;
  final String content;
  final TimeOfDay time;

  Message({this.sender, this.content, this.time});
}
