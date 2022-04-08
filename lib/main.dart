import 'package:flutter/material.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SudokuHomePage(title: 'Sudoku'),
    );
  }
}

class SudokuHomePage extends StatefulWidget {
  const SudokuHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SudokuHomePage> createState() => _SudokuHomePageState();
}

class _SudokuHomePageState extends State<SudokuHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          children: <Widget>[
            Column(
              children: [
                GestureDetector(
                  child: Container(
                    child: const Icon(Icons.add, size: 48, color: Colors.white),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameWidget()),
                    );
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

class GameWidget extends StatefulWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  State<GameWidget> createState() => _GameState();
}

class _GameState extends State<GameWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SudokuBoard()),
    );
  }
}

class SudokuBoard extends StatefulWidget {
  const SudokuBoard({Key? key}) : super(key: key);

  @override
  State<SudokuBoard> createState() => _SudokuState();
}

class _SudokuState extends State<SudokuBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        const Divider(height: 3),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        const Divider(height: 3),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
        Row(children: const [
          Cell(text: "1"),
          Cell(text: "2"),
          Cell(text: "3"),
          VerticalDivider(width: 3),
          Cell(text: "4"),
          Cell(text: "5"),
          Cell(text: "6"),
          VerticalDivider(width: 3),
          Cell(text: "7"),
          Cell(text: "8"),
          Cell(text: "9")
        ], mainAxisAlignment: MainAxisAlignment.center),
      ],
    );
  }
}

class Cell extends StatelessWidget {
  final String text;

  const Cell({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(1),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      )),
    );
  }
}
