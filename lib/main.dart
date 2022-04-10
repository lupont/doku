import 'package:flutter/material.dart';

import 'picker.dart';
import 'util.dart';
import 'board.dart';

const DIM = 9;

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
      theme: ThemeData(primarySwatch: Colors.blue),
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
        title: Text(title),
      ),
      body: Center(
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SudokuBoard(),
          ],
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
  int? _selectedIndex;

  Board _board = Board(3);

  void setSelected(int? index) {
    if (_selectedIndex == index) {
      _selectedIndex = null;
    } else {
      _selectedIndex = index;
    }
  }

  List<Widget> _getCells() {
    return List.generate(
      DIM * DIM,
      (i) {
        bool buddy = false;
        if (_selectedIndex != null) {
          int y = _selectedIndex! % DIM;
          int x = _selectedIndex! ~/ DIM;
          var sets = getBuddies(x, y)!;
          buddy = sets['row']!.contains(i) ||
              sets['col']!.contains(i) ||
              sets['sub']!.contains(i);
        }
        var cell = Cell(
          index: i,
          value: _board.at(i),
          buddy: buddy,
          highlight: _selectedIndex == null
              ? false
              : _board.at(_selectedIndex!) == _board.at(i),
          selected: _selectedIndex == i,
        );
        double right = i % 9 == 2 || i % 9 == 5 ? 3 : 0;
        double bottom = i >= 18 && i <= 26 || i >= 45 && i <= 53 ? 3 : 0;
        return Container(
          child: GestureDetector(
            child: cell,
            onTap: () {
              setState(() => setSelected(i));
            },
          ),
          padding: EdgeInsets.only(right: right, bottom: bottom),
        );
      },
    );
  }

  Widget gameOver(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text),
      ),
    );
  }

  void _checkWin(BuildContext context) {
    if (_board.isFinished()) {
      if (_board.isCorrect()) {
        showDialog(
          context: context,
          builder: (c) {
            return gameOver("YOU WIN!!!");
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return gameOver("You lose...");
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 9,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: _getCells(),
        ),
        Picker(
          enabled: _selectedIndex != null,
          onTap: (value) {
            setState(() {
              if (_board.at(_selectedIndex!) == value) {
                _board.set(_selectedIndex!, null);
              } else {
                _board.set(_selectedIndex!, value);
                _checkWin(context);
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.start),
          onPressed: () {
            setState(() {
              _board = Board(3);
              _selectedIndex = null;
            });
          },
        ),
      ],
    );
  }
}

class Cell extends StatefulWidget {
  final int index;
  final int? value;
  final bool selected;
  final bool highlight;
  final bool buddy;

  const Cell({
    Key? key,
    required this.index,
    required this.value,
    required this.selected,
    required this.highlight,
    required this.buddy,
  }) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.selected
        ? Colors.blue
        : widget.buddy
            ? const Color.fromARGB(255, 230, 230, 230)
            : Colors.white;
    Color foregroundColor = widget.selected
        ? Colors.white
        : widget.highlight
            ? Colors.blue
            : Colors.black;
    return GestureDetector(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Center(
          child: Text(
            widget.value == null ? "" : widget.value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: foregroundColor,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
