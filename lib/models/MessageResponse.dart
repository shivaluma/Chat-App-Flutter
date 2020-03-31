import 'package:chat_app/models/Message.dart';

class MessageResponse {
  final List<Message> listMsg;
  int newLast;
  MessageResponse({this.listMsg, this.newLast});
}
