import 'package:flutter/material.dart';

import 'package:sudoku/picker.dart';

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

  final List<int?> _values = List.generate(81, (_) => null);

  @override
  void initState() {
    super.initState();
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
        var cell = Cell(
          index: i,
          value: _values[i],
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
              _values[_selectedIndex!] = value;
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

  const Cell({
    Key? key,
    required this.index,
    required this.value,
    required this.selected,
  }) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.selected ? Colors.blue : Colors.white;
    Color foregroundColor = widget.selected ? Colors.white : Colors.black;
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
