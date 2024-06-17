import 'package:ansi_text/ansi_text.dart';
import 'package:ansi_text/src/ansi_escape_codes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = AnsiTextController(
    text:
        '${AnsiEscapeCodes.boldStartCode}Hello world!${AnsiEscapeCodes.reset}${AnsiEscapeCodes.newLine}',
    lineLimit: 100,
  );

  int lineCount = 0;
  void overFill() {
    final text = [
      lineCount++,
      AnsiEscapeCodes.boldStartCode,
      'Bolded ',
      AnsiEscapeCodes.boldClearCode,
      AnsiEscapeCodes.italicStartCode,
      'Italics ',
      AnsiEscapeCodes.italicClearCode,
      AnsiEscapeCodes.underlineStartCode,
      'Underlined',
      AnsiEscapeCodes.underlineClearCode,
      for (final i in List.generate(16, (index) => index)) ...[
        AnsiEscapeCodes.reset,
        ' ',
        if (i == 15) AnsiEscapeCodes.backgroundColorCode(0),
        AnsiEscapeCodes.foregroundColorCode(i),
        'Colored',
      ],
      for (final i in List.generate(15, (index) => index + 1)) ...[
        AnsiEscapeCodes.reset,
        ' ',
        AnsiEscapeCodes.backgroundColorCode(i),
        'Colored',
      ],
      AnsiEscapeCodes.reset,
      AnsiEscapeCodes.newLine,
    ].join();
    controller.writeLn(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: AnsiWidgetListView(
        controller: controller,
        selectable: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: overFill,
        child: const Icon(Icons.add),
      ),
    );
  }
}
