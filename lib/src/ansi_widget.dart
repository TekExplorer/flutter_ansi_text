import 'package:ansi_text/src/ansi_parser.dart';
import 'package:ansi_text/src/ansi_theme.dart';
import 'package:ansi_text/src/controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AnsiWidget extends StatefulWidget {
  const AnsiWidget({
    super.key,
    required this.controller,
    this.selectable = false,
    this.softWrap,
    TextStyle? style,
  }) : _style = style;

  final AnsiTextController controller;
  final bool selectable;
  final bool? softWrap;
  final TextStyle? _style;
  static final RegExp stripAnsiRegex = RegExp(
      '[\u001B\u009B][[\\]()#;?]*(?:(?:(?:[a-zA-Z\\d]*(?:;[a-zA-Z\\d]*)*)?\u0007)|(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PRZcf-ntqry=><~]))');

  @override
  State<AnsiWidget> createState() => _AnsiWidgetState();
}

class _AnsiWidgetState extends State<AnsiWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final lines = widget.controller.lines;
    // print(text.replaceAll('\x1B', r'\x1B'));
    final colorScheme = Theme.of(context).colorScheme;
    final style = widget._style ?? Theme.of(context).textTheme.bodyMedium;

    final ansiParser = AnsiParser(
      style: AnsiTheme(
        foregroundColor: colorScheme.onBackground,
        backgroundColor: colorScheme.background,
      ),
    );

    final parsedLines = lines.map(ansiParser.parse).flattened;

    if (widget.selectable) {
      final backTextSpan = TextSpan(
        style: style,
        children: [
          for (final (text, state) in parsedLines)
            TextSpan(
              text: text.replaceAll(AnsiWidget.stripAnsiRegex, ''),
              style: state
                  .toTextStyle(style: style)
                  .copyWith(color: Colors.transparent),
            )
        ],
      );
      final frontTextSpan = TextSpan(
        style: style,
        children: [
          for (final (text, state) in parsedLines)
            TextSpan(
              text: text.replaceAll(AnsiWidget.stripAnsiRegex, ''),
              style: state
                  .toTextStyle(style: style)
                  .copyWith(backgroundColor: Colors.transparent),
            )
        ],
      );
      return Container(
        color: ansiParser.style.backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: SelectionArea(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Text.rich(
                backTextSpan,
                softWrap: widget.softWrap,
              ),
              Text.rich(
                frontTextSpan,
                softWrap: widget.softWrap,
              ),
            ],
          ),
        ),
      );
    }
    final textSpan = TextSpan(
      style: style,
      children: [
        for (final (text, state) in parsedLines)
          TextSpan(
            text: text.replaceAll(AnsiWidget.stripAnsiRegex, ''),
            style: state.toTextStyle(style: style),
          ),
      ],
    );

    // TODO: make selection persist as value is updated
    // TODO: make selection work across scroll
    return Container(
      color: ansiParser.style.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text.rich(
        textSpan,
        softWrap: widget.softWrap,
      ),
    );
  }
}
