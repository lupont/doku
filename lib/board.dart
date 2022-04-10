import 'util.dart' as util;

import 'dart:math';

class Board {
  late List<int?> _values;
  late int _dim;
  late int _width;

  Board(int dim) {
    _values = List.generate(dim * dim * dim, (i) => null);
    _dim = dim;
    _width = dim * dim;

    _generate();
  }

  Board.from(List<int?> values, int dim) {
    _values = values;
    _dim = dim;
    _width = dim * dim;
  }

  int? at(int index) {
    if (index >= 0 && index < _values.length) {
      return _values[index];
    }
    return null;
  }

  void set(int index, int? value) {
    if (index >= 0 && index < _values.length) {
      _values[index] = value;
    }
  }

  void _generate() {
    do {
      _values = List.generate(_dim * _dim * _dim * _dim, (_) => null);
    } while (!_solve());

    List<int> indices = List.generate(_dim * _dim * _dim * _dim, (i) => i)
      ..shuffle();

    int i = 0;

    while (i < indices.length) {
      int index = indices[i];
      int? oldValue = _values[index];
      _values[index] = null;

      List<int?> copyValues = [..._values];
      Board copy = Board.from(copyValues, _dim);

      if (!copy._solve()) {
        _values[index] = oldValue;
      }

      ++i;
    }
  }

  bool _solve() {
    if (isFinished()) {
      return true;
    }

    List<int> values = List.generate(_width, (i) => i + 1)..shuffle();

    for (int i = 0; i < _width; ++i) {
      for (int j = 0; j < _width; ++j) {
        int index = i * _width + j;
        if (_values[index] != null) continue;

        for (int value in values) {
          if (isValid(value, index)) {
            _values[index] = value;

            if (_solve()) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  bool isFinished() {
    return _values.every((e) => e != null);
  }

  bool isCorrect() {
    if (isFinished()) {
      List<int?> copyValues = [..._values];
      Board copy = Board.from(copyValues, _dim);
      return copy._solve();
    }
    return false;
  }

  bool isValid(int subject, int index) {
    int y = index % _width;
    int x = index ~/ _width;

    var buddies = util.getBuddies(x, y)!;

    var row = buddies['row']!.map((i) => _values[i]).toList();
    var col = buddies['col']!.map((i) => _values[i]).toList();
    var sub = buddies['sub']!.map((i) => _values[i]).toList();

    return !row.contains(subject) &&
        !col.contains(subject) &&
        !sub.contains(subject);
  }
}
