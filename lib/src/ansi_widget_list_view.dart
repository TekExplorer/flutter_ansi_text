import 'package:ansi_text/ansi_text.dart';
import 'package:flutter/material.dart';

class AnsiWidgetListView extends StatefulWidget {
  const AnsiWidgetListView({
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
  State<AnsiWidgetListView> createState() => _AnsiWidgetListViewState();
}

class _AnsiWidgetListViewState extends State<AnsiWidgetListView> {
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
    final lines = widget.controller.lines.reversed.toList();
    // print(text.replaceAll('\x1B', r'\x1B'));
    final colorScheme = Theme.of(context).colorScheme;
    final style = widget._style ?? Theme.of(context).textTheme.bodyMedium;

    final ansiParser = AnsiParser(
      style: AnsiTheme(
        foregroundColor: colorScheme.onBackground,
        backgroundColor: colorScheme.background,
      ),
    );

    if (widget.selectable) {
      return Container(
        color: ansiParser.style.backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: SelectionArea(
          child: ListView.builder(
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final parsedLine = ansiParser.parse(lines[index]);
              return Stack(
                fit: StackFit.passthrough,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        for (final (text, state) in parsedLine)
                          TextSpan(
                            text:
                                text.replaceAll(AnsiWidget.stripAnsiRegex, ''),
                            style: state
                                .toTextStyle(style: style)
                                .copyWith(color: Colors.transparent),
                          ),
                      ],
                    ),
                    softWrap: widget.softWrap,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        for (final (text, state) in parsedLine)
                          TextSpan(
                            text:
                                text.replaceAll(AnsiWidget.stripAnsiRegex, ''),
                            style: state
                                .toTextStyle(style: style)
                                .copyWith(backgroundColor: Colors.transparent),
                          ),
                      ],
                    ),
                    softWrap: widget.softWrap,
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    return Container(
      color: ansiParser.style.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(0),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          return Text.rich(
            TextSpan(
              children: [
                for (final (text, state) in ansiParser.parse(lines[index]))
                  TextSpan(
                    text:
                        text.replaceAll(AnsiWidgetListView.stripAnsiRegex, ''),
                    style: state.toTextStyle(style: style),
                  ),
              ],
            ),
            softWrap: widget.softWrap,
          );
        },
      ),
    );
  }
}
