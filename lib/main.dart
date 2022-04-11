import 'package:flutter/material.dart';
import 'dart:async';

import 'board.dart';
import 'picker.dart';
import 'settings.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SudokuHomePage(title: 'Sudoku'),
    );
  }
}

class Settings {
  late bool gridHints;
  late bool highlightSame;
  late bool prefillDifferentColor;

  Settings() {
    gridHints = false;
    highlightSame = true;
    prefillDifferentColor = true;
  }

  void set(String setting, dynamic value) {
    switch (setting) {
      case "grid_hints":
        if (value is bool) {
          gridHints = value;
        }
        break;
      case "highlight_same":
        if (value is bool) {
          highlightSame = value;
        }
        break;
      case "prefill_different_color":
        if (value is bool) {
          prefillDifferentColor = value;
        }
        break;
    }
  }
}

class SudokuHomePage extends StatefulWidget {
  final String title;
  const SudokuHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<SudokuHomePage> createState() => _SudokuHomePageState();
}

class _SudokuHomePageState extends State<SudokuHomePage> {
  final Settings _settings = Settings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
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
                    builder: (context) => GameWidget(settings: _settings),
                  ),
                );
              },
            ),
            GestureDetector(
              child: Container(
                child:
                    const Icon(Icons.settings, size: 48, color: Colors.white),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      settings: _settings,
                    ),
                  ),
                );
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }
}

class GameWidget extends StatelessWidget {
  final Settings settings;
  const GameWidget({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SudokuBoard(settings: settings),
          ],
        ),
      ),
    );
  }
}

class SudokuBoard extends StatefulWidget {
  final Settings settings;
  const SudokuBoard({Key? key, required this.settings}) : super(key: key);

  @override
  State<SudokuBoard> createState() => _SudokuState();
}

class _SudokuState extends State<SudokuBoard> {
  int? _selectedIndex;

  Board _board = Board(3);
  List<bool> _checked = List.generate(DIM * DIM, (_) => false);

  void setSelected(int? index) {
    if (_selectedIndex == index) {
      _selectedIndex = null;
    } else {
      _selectedIndex = index;
    }
  }

  List<Container> _getCells() {
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
          prefilled: _board.isPrefilled(i),
          buddy: buddy,
          highlight: _selectedIndex == null
              ? false
              : _board.at(_selectedIndex!) == _board.at(i),
          selected: _selectedIndex == i,
          checked: _checked[i],
          settings: widget.settings,
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
    const tickInterval = Duration(milliseconds: 30);
    if (_board.isFinished()) {
      int index = 0;
      Timer.periodic(tickInterval, (timer) {
        setState(() {
          if (index >= _checked.length) {
            timer.cancel();
          }
          _checked[index++] = true;
        });
      });
      Future.delayed(tickInterval * DIM * DIM, () {
        showDialog(
          context: context,
          builder: (c) {
            return gameOver(_board.isCorrect() ? "YOU WIN!!!" : "You lose...");
          },
        );
      });
    }
  }

  void _resetChecked() {
    setState(() {
      _checked = List.generate(DIM * DIM, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var cells = _getCells();
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 9,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: cells,
        ),
        Picker(
          enabled: _selectedIndex != null,
          onTap: (value) {
            _resetChecked();
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
              _resetChecked();
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
  final bool checked;
  final bool prefilled;
  final Settings settings;

  const Cell({
    Key? key,
    required this.index,
    required this.value,
    required this.selected,
    required this.highlight,
    required this.buddy,
    required this.checked,
    required this.settings,
    required this.prefilled,
  }) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.selected
        ? Colors.blue
        : widget.buddy && widget.settings.gridHints
            ? const Color.fromARGB(255, 230, 230, 230)
            : Colors.white;
    Color foregroundColor = widget.selected
        ? Colors.white
        : widget.highlight && widget.settings.highlightSame
            ? Colors.blue
            : widget.prefilled && widget.settings.prefillDifferentColor
                ? const Color.fromARGB(255, 90, 90, 90)
                : Colors.black;

    if (widget.checked) {
      backgroundColor = Colors.green;
      foregroundColor = Colors.white;
    }

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
