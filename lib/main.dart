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

class SudokuHomePage extends StatelessWidget {
  const SudokuHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
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
                    child: const Icon(
                      Icons.add,
                      size: 48,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameWidget(),
                      ),
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

class GameWidget extends StatelessWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SudokuBoard(),
        ),
      ),
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
    return GridView.count(
      crossAxisCount: 9,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      children: List.generate(
        81,
        (i) {
          var cell = Cell(index: i);
          double right = i % 9 == 2 || i % 9 == 5 ? 3 : 0;
          double bottom = i >= 18 && i <= 26 || i >= 45 && i <= 53 ? 3 : 0;
          return Container(
            child: cell,
            padding: EdgeInsets.only(right: right, bottom: bottom),
          );
        },
      ),
    );
  }
}

class Cell extends StatefulWidget {
  int index;
  bool visible = true;

  Cell({Key? key, required this.index}) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.visible ^= true;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Center(
          child: Visibility(
            child: Text(
              "${widget.index}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            visible: widget.visible,
          ),
        ),
      ),
    );
  }
}
