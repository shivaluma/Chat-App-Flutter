import 'package:chat_app/models/User.dart';
import 'package:flutter/material.dart';

class Conversation {
  final String id;
  final String firstId;
  final String secondId;
  final String firstUserName;
  final String secondUserName;
  final String lastMessage;
  final String lastSender;
  final String lastUpdate;
  Conversation(
      {this.id,
      this.firstId,
      this.secondId,
      this.firstUserName,
      this.secondUserName,
      this.lastMessage,
      this.lastSender,
      this.lastUpdate});
  factory Conversation.fromJson(Map<String, dynamic> json) {
    var datetime = DateTime.parse(json['lastUpdate']);
    return Conversation(
      id: json['_id'],
      firstId: json['firstId'],
      secondId: json['secondId'],
      firstUserName: json['firstUserName'],
      secondUserName: json['secondUserName'],
      lastMessage: json['lastMessage'],
      lastSender: json['lastSender'],
      lastUpdate: ((datetime.hour + 7) % 24).toString() +
          ":" +
          (datetime.minute < 10 ? "0" : "") +
          datetime.minute.toString(),
    );
  }
}

List<Conversation> cvs = [];
