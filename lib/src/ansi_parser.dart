import 'package:ansi_text/src/ansi_state.dart';
import 'package:ansi_text/src/ansi_theme.dart';
import 'package:flutter/material.dart';

class AnsiParser {
  const AnsiParser({required this.style});
  final AnsiTheme style;

  // Matches ansi codes
  static final RegExp ansiCodeRegex = RegExp(r'\x1B\[((?:\d|;)+)m([^\x1B]*)');

  // TODO: does this need access to the last state?
  // TODO: Linkify support in https://pub.dev/packages/linkify

  /// Only parses out color/formatting codes
  List<(String, AnsiState)> parse(String input) {
    input = input.replaceAll('\n\r', '\n');
    final List<(String, AnsiState)> result = [];

    AnsiState currentState = AnsiState(
      foregroundColor: style.foregroundColor,
      backgroundColor: style.backgroundColor,
      defaultBackgroundColor: style.backgroundColor,
    );

    final Iterable<Match> matches = ansiCodeRegex.allMatches(input);

    // ensure anything before a code is shown
    if (matches.isNotEmpty && matches.first.start != 0) {
      final sub = input.substring(0, matches.first.start);
      result.add((sub, currentState));
    }

    for (final Match match in matches) {
      final String ansiCode = match.group(1)!;
      final String text = match.group(2)!;

      final List<int> codes =
          ansiCode.split(';').map((code) => int.tryParse(code) ?? 0).toList();

      currentState = _parseCodes(currentState.copyWith(), codes);

      // Create a copy to avoid sharing the same style object
      result.add((text, currentState.copyWith()));
    }
    return result;
  }

  AnsiState _parseCodes(AnsiState state, List<int> codes) {
    return switch (codes) {
      [38, 5, final int code] => state.copyWith(
          foregroundColor: switch (code) {
            < 16 => _combinedColors[code],
            >= 16 && <= 231 => _cubeColorFromInt(code - 16),
            _ => throw ArgumentError(),
          },
        ),
      [48, 5, final int code] => state.copyWith(
          backgroundColor: switch (code) {
            < 16 => _combinedColors[code],
            >= 16 && <= 231 => _cubeColorFromInt(code - 16),
            _ => throw ArgumentError(),
          },
        ),
      [38, 2, final int r, final int g, final int b] =>
        state.copyWith(foregroundColor: Color.fromRGBO(r, g, b, 1)),
      [48, 2, final int r, final int g, final int b] =>
        state.copyWith(backgroundColor: Color.fromRGBO(r, g, b, 1)),
      _ => codes.fold(
          state,
          (state, code) =>
              switch (code) {
                0 => AnsiState(
                    foregroundColor: style.foregroundColor,
                    backgroundColor: style.backgroundColor,
                    defaultBackgroundColor: state.defaultBackgroundColor,
                  ),
                1 => state.copyWith(weight: FontWeight.bold),
                2 => state.copyWith(weight: FontWeight.w200),
                3 => state.copyWith(italic: true),
                4 => state.copyWith(underlined: true),
                5 => state.copyWith(blink: true),
                6 => null,
                7 => state.copyWith(inverted: true),
                8 => state.copyWith(hidden: true),
                9 => state.copyWith(strikethrough: true),

                // 10 - 21 ??

                22 => state.copyWith(weight: FontWeight.normal),
                23 => state.copyWith(italic: false),
                24 => state.copyWith(underlined: false),
                25 => state.copyWith(blink: false),
                26 => null,
                27 => state.copyWith(inverted: false),
                28 => state.copyWith(hidden: false),
                29 => state.copyWith(strikethrough: false),
                // default
                39 => state.copyWith(foregroundColor: style.foregroundColor),
                // default
                49 => state.copyWith(backgroundColor: style.backgroundColor),
                >= 30 && <= 37 =>
                  state.copyWith(foregroundColor: _colors[code % 10]),
                // bg
                >= 40 && <= 47 =>
                  state.copyWith(backgroundColor: _colors[code % 10]),
                //
                // bright
                >= 90 && <= 97 =>
                  state.copyWith(foregroundColor: _brightColors[code % 10]),
                // bright bg
                >= 100 && <= 107 =>
                  state.copyWith(backgroundColor: _brightColors[code % 10]),
                _ => null,
              } ??
              state,
        ),
    };
  }

  Color _cubeColorFromInt(int code) {
    final ogCode = code;
    final b = code ~/ 6;
    // print('b: $b');

    code -= b;
    code = code ~/ 6;

    final g = code % 6;
    // print('g: $g');

    code -= g;
    code = code ~/ 6;

    final r = code % 6;
    // print('r: $r');

    final expected = (36 * r) + (6 * g) + b;

    assert(expected == ogCode, "Didn't work!");
    assert(code == 0, "Didn't clear!");
    return Color.fromRGBO(r, g, b, 1);
  }

  List<Color> get _colors => [
        style.theme.black,
        style.theme.red,
        style.theme.green,
        style.theme.yellow,
        style.theme.blue,
        style.theme.magenta,
        style.theme.cyan,
        style.theme.white,
      ];

  List<Color> get _brightColors => [
        style.brightTheme.black,
        style.brightTheme.red,
        style.brightTheme.green,
        style.brightTheme.yellow,
        style.brightTheme.blue,
        style.brightTheme.magenta,
        style.brightTheme.cyan,
        style.brightTheme.white,
      ];

  List<Color> get _combinedColors => [
        ..._colors,
        ..._brightColors,
      ];
}
