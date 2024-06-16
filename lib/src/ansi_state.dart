import 'package:flutter/material.dart';

class AnsiState {
  const AnsiState({
    this.weight = FontWeight.normal,
    this.italic = false,
    this.underlined = false,
    this.blink = false,
    this.inverted = false,
    this.hidden = false,
    this.strikethrough = false,
    required this.foregroundColor,
    required this.backgroundColor,
    //
    required this.defaultBackgroundColor,
  });

  final FontWeight weight;
  final bool italic;
  final bool underlined;
  final bool blink;
  final bool inverted;
  final bool hidden;
  final bool strikethrough;
  final Color foregroundColor;
  final Color backgroundColor;
  //
  final Color defaultBackgroundColor;

  TextStyle toTextStyle({TextStyle? style}) {
    // TODO: blink?
    final fg = inverted ? backgroundColor : foregroundColor;
    final bg = inverted ? foregroundColor : backgroundColor;
    style ??= const TextStyle();
    return style.copyWith(
      fontWeight: weight,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      color: hidden ? Colors.transparent : fg,
      backgroundColor: bg == defaultBackgroundColor ? null : bg,
      decoration: TextDecoration.combine([
        if (underlined) TextDecoration.underline,
        if (strikethrough) TextDecoration.lineThrough,
      ]),
    );
  }

  AnsiState copyWith({
    FontWeight? weight,
    bool? italic,
    bool? underlined,
    bool? blink,
    bool? inverted,
    bool? hidden,
    bool? strikethrough,
    Color? foregroundColor,
    Color? backgroundColor,
  }) =>
      AnsiState(
        weight: weight ?? this.weight,
        italic: italic ?? this.italic,
        underlined: underlined ?? this.underlined,
        blink: blink ?? this.blink,
        inverted: inverted ?? this.inverted,
        hidden: hidden ?? this.hidden,
        strikethrough: strikethrough ?? this.strikethrough,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        defaultBackgroundColor: defaultBackgroundColor,
      );

  @override
  String toString() {
    return 'AniState('
        'weight: $weight, '
        'italic: $italic, '
        'underlined: $underlined '
        // 'blink: $blink '
        'inverted: $inverted '
        'hidden: $hidden '
        'strikethrough: $strikethrough '
        'foregroundColor: $foregroundColor '
        'backgroundColor: $backgroundColor'
        ')';
  }
}
