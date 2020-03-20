import 'package:chat_app/models/User.dart';
import 'package:flutter/material.dart';

class Conversation {
  final User me;
  final User other;
  final String lastMessage;
  final String lastSender;
  final String lastTime;
  Conversation(
      {this.me, this.other, this.lastMessage, this.lastSender, this.lastTime});
}

final cv1 = Conversation(
    lastMessage: "Yeu thao",
    me: shiro,
    other: tamlol,
    lastSender: "Tamgay",
    lastTime: "11:39");
final cv2 = Conversation(
    lastMessage: "Thanh qua dep trai",
    me: shiro,
    other: tailong,
    lastSender: "Mob",
    lastTime: "11:40");

List<Conversation> cvs = [cv1, cv2, cv2, cv2, cv2, cv2, cv2];
