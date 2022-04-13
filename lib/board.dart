import 'util.dart' as util;

class Board {
  late List<int?> _values;
  late List<bool> _prefilled;
  late int _dim;
  late int _width;

  Board(int dim) {
    final width = dim * dim;
    _values = List.generate(width * width, (i) => null);
    _prefilled = List.generate(width * width, (i) => false);

    _dim = dim;
    _width = width;

    _generate();
  }

  bool isPrefilled(int index) {
    if (index < 0 || index >= _prefilled.length) {
      return false;
    }
    return _prefilled[index];
  }

  Board.from(Board board) {
    _values = [...board._values];
    _prefilled = [...board._prefilled];
    _dim = board._dim;
    _width = board._dim * board._dim;
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
      _prefilled[index] = false;
    }
  }

  void _generate() {
    do {
      _values = List.generate(_width * _width, (_) => null);
    } while (!_solve());

    List<int> indices = List.generate(_width * _width, (i) => i)..shuffle();

    int i = 0;

    while (i < indices.length) {
      int index = indices[i];
      int? oldValue = _values[index];

      _values[index] = null;
      _prefilled[index] = false;

      Board copy = Board.from(this);

      if (!copy._solve()) {
        _values[index] = oldValue;
        _prefilled[index] = true;
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
            _prefilled[index] = true;

            if (_solve()) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  bool eq(List<int?> a, List<int?> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; ++i) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  bool checkWin() {
    final values = List.generate(_width, (i) => i + 1);

    for (int i = 0; i < _width; ++i) {
      var rowB = util.getBuddies(0, i, self: true)!;
      var colB = util.getBuddies(i, 0, self: true)!;

      var rrows = rowB['row']!.map((i) => _values[i]).toList();
      rrows.sort();
      var rcols = rowB['col']!.map((i) => _values[i]).toList();
      rcols.sort();

      var crows = colB['row']!.map((i) => _values[i]).toList();
      crows.sort();
      var ccols = colB['col']!.map((i) => _values[i]).toList();
      ccols.sort();

      if (!eq(rrows, values) ||
          !eq(rcols, values) ||
          !eq(crows, values) ||
          !eq(ccols, values)) {
        return false;
      }
    }

    for (int i = 0; i < _dim; i += 3) {
      for (int j = 0; j < _dim; j += 3) {
        var sub = util
            .getBuddies(i, j, self: true)!['sub']!
            .map((i) => _values[i])
            .toList();
        sub.sort();
        if (!eq(sub, values)) {
          return false;
        }
      }
    }
    return true;
  }

  bool isFinished() {
    return _values.every((e) => e != null);
  }

  bool isCorrect() {
    if (isFinished()) {
      final won = checkWin();
      if (won) {
        print("WON!");
        return true;
      } else {
        print("lost...");
        return false;
      }
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
