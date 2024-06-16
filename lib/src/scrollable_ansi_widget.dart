import 'package:ansi_text/src/ansi_widget.dart';
import 'package:ansi_text/src/controller.dart';
import 'package:flutter/material.dart';

class ScrollableAnsiWidget extends StatelessWidget {
  const ScrollableAnsiWidget({
    super.key,
    required this.controller,
    this.selectable = false,
    this.style,
  });
  final AnsiTextController controller;
  final bool selectable;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          reverse: true,
          child: SizedBox(
            height: constraints.maxHeight,
            child: AnsiWidget(
              controller: controller,
              selectable: selectable,
            ),
          ),
        );
      },
    );
  }
}
