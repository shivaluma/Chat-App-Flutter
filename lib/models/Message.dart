class Message {
  final String id;
  final String ofUser;
  final String content;
  final String time;

  Message({this.id, this.ofUser, this.content, this.time});

  factory Message.fromJson(Map<String, dynamic> json) {
    var datetime = DateTime.parse(json['time']);

    return Message(
      id: json['id'],
      ofUser: json['ofUser'],
      content: json['content'],
      time: ((datetime.hour + 7) % 24).toString() +
          ":" +
          (datetime.minute < 10 ? "0" : "") +
          datetime.minute.toString(),
    );
  }
}
