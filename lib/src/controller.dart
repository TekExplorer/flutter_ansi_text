import 'dart:collection';

import 'package:flutter/material.dart';

class AnsiTextController extends ChangeNotifier {
  AnsiTextController({String? text, this.lineLimit = -1})
      : _textLines = text == null ? ListQueue() : ListQueue.from([text]);

  AnsiTextController.from(Iterable<String> lines, {this.lineLimit = -1})
      : _textLines = ListQueue.from(lines);

  final ListQueue<String> _textLines;
  int lineLimit;

  List<String> get lines => [..._textLines];

  /// Add a line
  void writeLn(String line) => writeAll([line]);

  void writeAll(Iterable<String> lines) {
    _textLines.addAll(lines);
    _trimLinesTo(lines: lineLimit);
    notifyListeners();
  }

  void clear() {
    _textLines.clear();
    notifyListeners();
  }

  /// Removes most recent line
  String removeLastLine() {
    if (_textLines.isEmpty) return '';
    final last = _textLines.removeLast();
    notifyListeners();
    return last;
  }

  /// Removes an old line
  String removeLine() {
    if (_textLines.isEmpty) return '';
    final first = _textLines.removeFirst();
    notifyListeners();
    return first;
  }

  /// Removes old lines
  List<String> removeLines(int count) {
    final lines = <String>[];
    for (int i = 0; i < count; i++) {
      if (_textLines.isEmpty) break;
      lines.add(_textLines.removeFirst());
    }
    notifyListeners();
    return lines;
  }

  /// Update the line limit to [limit]
  /// -1 means no limit.
  /// Automatically trims if [limit] is lower than the current length
  void limitLinesTo(int limit) {
    lineLimit = limit;
    _trimLinesTo(lines: limit);
    notifyListeners();
  }

  /// Remove old lines until we have exactly this many
  /// -1 early-returns
  void _trimLinesTo({required int lines}) {
    if (lines < 0) return;
    final overflow = _textLines.length - lines;
    if (overflow <= 0) return;
    removeLines(overflow);
  }
}
