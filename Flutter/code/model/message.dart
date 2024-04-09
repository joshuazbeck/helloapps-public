import 'package:palette_chat/model/session.dart';

class Message {
  int id;
  String text;
  int sessionId;

  Message(this.id, this.text, this.sessionId);

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        text = json['text'] as String,
        sessionId = json['session_id'] as int;

  Map<String, dynamic> toJson() =>
      {'id': id, 'text': text, 'session_id': sessionId};

  Session? session;
}
