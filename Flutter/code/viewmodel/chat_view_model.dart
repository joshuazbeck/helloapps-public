import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palette_chat/model/message.dart';
import 'package:palette_chat/service/messaging_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatViewModel with ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  int? _sessionId;
  int? get sessionId => _sessionId;

  void setSessionId(int? sessionId) {
    _sessionId = sessionId;
    notifyListeners();
  }

  //TODO: Implement scrollController

  //TODO: Implement _scrollDown()

  void destroy() {
    MessagingService().disconnectSocket();
    _isLoading = true;
    _messages = [];
    _sessionId = null;
  }

  /// Called first to initialize the view model with messages
  Future<int?> initializeSocketMessages(String name, String colorHex) async {
    _isLoading = true;

    var messages = await MessagingService().listMessages();
    endLoading();

    _messages = messages;
    notifyListeners();

    var socketId =
        await MessagingService().listenToSocket(name, colorHex, (sessionId) {
      refreshMessages();
    });

    return socketId;
  }

  void sendMessage(TextEditingController controller, int? sessionId) {
    if (sessionId != null && controller.text.isNotEmpty) {
      MessagingService().sendMessage(controller.text, sessionId).then((value) {
        controller.clear();
      });
    } else {
      print("Issue sending the message for session id: $sessionId");
    }
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void refreshMessages() {
    MessagingService().listMessages().then((messages) {
      _messages = messages;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => {_scrollDown()});
    });
  }
}
