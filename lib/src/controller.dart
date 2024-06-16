import 'package:flutter/material.dart';

class AnsiTextController extends ChangeNotifier {
  AnsiTextController({String? text}) : _textLines = text == null ? [] : [text];

  final List<String> _textLines;

  List<String> get lines => [..._textLines];

  void writeLn(String line) {
    _textLines.add(line);
    notifyListeners();
  }

  void clear() {
    _textLines.clear();
    notifyListeners();
  }

  void removeLastLine() {
    _textLines.removeLast();
    notifyListeners();
  }

  void removeLine() => removeLines(1);

  void removeLines(int count) {
    for (int i = count; i > 0; i--) {
      _textLines.removeAt(0);
    }
    notifyListeners();
  }
}
