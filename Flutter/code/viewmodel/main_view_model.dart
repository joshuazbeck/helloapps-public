import 'dart:math';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:palette_chat/view/chat.dart';

class MainViewModel with ChangeNotifier {
  String _userFullname = "";
  late Color _userColor;
  late String _userHex;

  MainViewModel() {
    _userColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    _userHex = _userColor.hex;
  }

  String get userFullname => _userFullname;
  String get userHex => _userHex;
  Color get userColor => _userColor;

  //TODO: Implement setUserFullname

  void setUserColorFromHex(String colorHex) {
    _userColor = colorHex.toColorShort(true); //Returns black if no return
    _userHex = colorHex;
    notifyListeners();
  }

  void setUserColor(Color color) {
    _userColor = color;
    _userHex = color.hex;
    notifyListeners();
  }

  String? validateFullname(String? name) {
    if (name == null || name.isEmpty) {
      return "Must specify a fullname";
    }
    return null;
  }

  String? validateUserColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return "Must specify a color hex";
    }
    if (colorHex.toColorMaybeNull == null) {
      return "Invalid color. Must be in hex format";
    }
    return null;
  }

  //TODO: Implement openChat(BuildContext context)
}
