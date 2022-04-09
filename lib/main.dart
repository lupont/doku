import 'dart:math';

import 'package:flutter/material.dart';

import 'picker.dart';
import 'util.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /* home: const SudokuHomePage(title: 'Sudoku'), */
      home: const GameWidget(),
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

  List<int?> _values = List.generate(81, (_) => null);

  void _generateBoard() {
    do {
      setState(() {
        _values = List.generate(81, (_) => null);
      });
    } while (!_solve());
  }

  bool _solve() {
    if (isFinished(_values)) {
      return true;
    }

    List<int> values = List.generate(9, (i) => i + 1);
    List<int> usedValues = [];
    var rng = Random();

    for (int i = 0; i < DIM; ++i) {
      for (int j = 0; j < DIM; ++j) {
        int index = i * DIM + j;
        if (_values[index] != null) continue;

        while (usedValues.length < values.length) {
          int value = values[rng.nextInt(values.length)];
          while (usedValues.contains(value)) {
            value = values[rng.nextInt(values.length)];
          }
          usedValues.add(value);

          if (isValid(value, index, _values)) {
            setState(() {
              _values[index] = value;
            });

            if (_solve()) {
              return true;
            }
          }
        }
        usedValues = [];
      }
    }

    return false;
  }

  void setSelected(int? index) {
    if (_selectedIndex == index) {
      _selectedIndex = null;
    } else {
      _selectedIndex = index;
    }
  }

  List<Widget> _getCells() {
    return List.generate(
      81,
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
          value: _values[i],
          buddy: buddy,
          highlight: _selectedIndex == null
              ? false
              : _values[_selectedIndex!] == _values[i],
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
              if (_values[_selectedIndex!] == value) {
                _values[_selectedIndex!] = null;
              } else {
                _values[_selectedIndex!] = value;
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.start),
          onPressed: () {
            _generateBoard();
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
