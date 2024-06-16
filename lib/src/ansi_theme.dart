import 'package:flutter/material.dart';

class AnsiTheme {
  AnsiTheme({
    AnsiTextTheme? theme,
    AnsiTextTheme? brightTheme,
    required this.backgroundColor,
    required this.foregroundColor,
  })  : theme = theme ?? AnsiTextTheme.normal,
        brightTheme = brightTheme ?? AnsiTextTheme.bright;

  final AnsiTextTheme theme;
  final AnsiTextTheme brightTheme;
  final Color backgroundColor;
  final Color foregroundColor;
}

class AnsiTextTheme {
  const AnsiTextTheme({
    required this.black,
    required this.red,
    required this.green,
    required this.yellow,
    required this.blue,
    required this.magenta,
    required this.cyan,
    required this.white,
  });

  static final AnsiTextTheme bright = AnsiTextTheme(
    black: Colors.grey,
    red: Colors.red.shade300,
    green: Colors.green.shade300,
    yellow: Colors.yellow.shade300,
    blue: Colors.blue.shade300,
    magenta: Magenta.magenta.shade300,
    cyan: Colors.cyan.shade300,
    white: Colors.white,
  );
  static final AnsiTextTheme normal = AnsiTextTheme(
    black: Colors.black,
    red: Colors.red,
    green: Colors.green,
    yellow: Colors.yellow,
    blue: Colors.blue,
    magenta: Magenta.magenta,
    cyan: Colors.cyan,
    white: Colors.grey.shade300,
  );

  final Color black;
  final Color red;
  final Color green;
  final Color yellow;
  final Color blue;
  final Color magenta;
  final Color cyan;
  final Color white;

  AnsiTextTheme copyWith({
    Color? black,
    Color? red,
    Color? green,
    Color? yellow,
    Color? blue,
    Color? magenta,
    Color? cyan,
    Color? white,
  }) {
    return AnsiTextTheme(
      black: black ?? this.black,
      red: red ?? this.red,
      green: green ?? this.green,
      yellow: yellow ?? this.yellow,
      blue: blue ?? this.blue,
      magenta: magenta ?? this.magenta,
      cyan: cyan ?? this.cyan,
      white: white ?? this.white,
    );
  }
}

class Magenta {
  static const magenta = MaterialColor(_magentaPrimary, _magentaSwatch);
  // Magenta color value (ARGB format)
  static const int _magentaPrimary = 0xFFFF00FF;

  static const Map<int, Color> _magentaSwatch = {
    50: Color(0xFFFFE4E1),
    100: Color(0xFFFFB6C1),
    200: Color(0xFFFF92A1),
    300: Color(0xFFFF7090),
    400: Color(0xFFFF5C8B),
    500: Color(_magentaPrimary),
    600: Color(0xFFFF4786),
    700: Color(0xFFFF3B82),
    800: Color(0xFFFF2F7E),
    900: Color(0xFFFF1F75),
  };
}
