import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:palette_chat/model/message.dart';
import 'package:palette_chat/model/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class MessagingService {
  //Static accesor
  MessagingService._privateConstructor();
  static MessagingService? _instance;
  factory MessagingService() =>
      _instance ??= MessagingService._privateConstructor();

  final String _baseUrl = "dev.joshzbeck.com";
  final String _apiTag = "/chatapi/v1";
  final String _socketUrl = 'https://dev.joshzbeck.com';

  String get socketURL => _socketUrl;
  String get baseUrl => _baseUrl;
  io.Socket? _socket;
  void disconnectSocket() {
    if (_socket != null) {
      _socket!.clearListeners();
    }
  }

  Future<int?> listenToSocket(String name, String colorHex,
      dynamic Function(dynamic) messageHandler) async {
    io.Socket socket = io.io(MessagingService().socketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket = socket;
    int? sessionId = await MessagingService().generateSession(name, colorHex);
    if (sessionId != null) {
      socket.connect();

      socket.onConnect((_) => print("Connected to the socket"));

      socket.onDisconnect((_) {
        print("Disconnected from socket");
        socket.clearListeners();
      });

      // Connect the current session to the socket
      socket.emit("add_session", sessionId);

      socket.on('send_message', messageHandler);
    } else {
      throw Exception("We couldn't connect to the session");
    }
    return sessionId;
  }

  Future<bool> sendMessage(String text, int sessionId) async {
    final body = {
      'text': text,
      'sessionId': sessionId,
    };

    final bodyJson = jsonEncode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final uri = Uri.https(_baseUrl, '$_apiTag/message/post');
    final response = await http.post(uri, headers: headers, body: bodyJson);

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json.containsKey("code") && json["code"] == 200) {
        return true;
      } else {
        throw Exception(json.containsKey("error") ? json["error"] : json);
      }
    } on FormatException catch (e) {
      throw Exception('The provided string is not valid JSON');
    }
  }

  Future<List<Message>> listMessages() async {
    var messages = await _getListMessages();

    // Attach the "session" objects to the message object
    for (var message in messages) {
      message.session = await _getSession(message.sessionId);
    }
    return messages;
  }

  Future<Message> getMessage(int id) async {
    final body = {
      'id': id,
    };
    final bodyJson = jsonEncode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final uri = Uri.https(_baseUrl, '$_apiTag/message/get');
    final response = await http.post(uri, headers: headers, body: bodyJson);

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json.containsKey("code") && json["code"] == 200) {
        Message message = Message.fromJson(json["message"]);
        Session session = await _getSession(message.sessionId);
        message.session = session;
        return message;
      } else {
        throw Exception(json.containsKey("error") ? json["error"] : json);
      }
    } on FormatException catch (e) {
      throw Exception('The provided string is not valid JSON');
    }
  }

  Future<int?> generateSession(String name, String colorHex) async {
    // /session/generate
    final body = {
      'name': name,
      'colorHex': colorHex,
    };
    final jsonString = jsonEncode(body);
    final uri = Uri.https(_baseUrl, '$_apiTag/session/generate');

    final response = await http.post(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonString);
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json["code"] == 200) {
        //We successfully sent a message
        return json["id"] as int?;
      } else {
        throw Exception(json["error"]);
      }
    } on FormatException catch (e) {
      print('The provided string is not valid JSON');
    }
    return null;
  }

  Future<List<Message>> _getListMessages() async {
    final uri = Uri.https(_baseUrl, '$_apiTag/message/list');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers); //GET

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json.containsKey("code") && json["code"] == 200) {
        return json["messages"].map<Message>((m) {
          return Message.fromJson(m);
        }).toList();
      } else {
        throw Exception(json.containsKey("error") ? json["error"] : json);
      }
    } on FormatException catch (e) {
      throw Exception('The provided string is not valid JSON');
    }
  }

  Future<Session> _getSession(int id) async {
    // /session/get
    final body = {
      'id': id,
    };
    final bodyJson = jsonEncode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final uri = Uri.https(_baseUrl, '$_apiTag/session/get');
    final response = await http.post(uri, headers: headers, body: bodyJson);

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json.containsKey("code") && json["code"] == 200) {
        return Session.fromJson(json["session"]);
      } else {
        throw Exception(json.containsKey("error") ? json["error"] : json);
      }
    } on FormatException catch (e) {
      throw Exception('The provided string is not valid JSON');
    }
  }
}
