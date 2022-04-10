import 'main.dart';

Map<String, List<int>>? getBuddies(int x, int y, {bool self = false}) {
  if (x < 0 || y < 0 || x >= DIM || y >= DIM) {
    return null;
  }

  List<int> row = [];
  List<int> col = [];
  List<int> subgrid = [];

  for (int i = 0; i < DIM; ++i) {
    if (self || i * DIM != x) {
      row.add(i * DIM + y);
    }
  }

  for (int j = 0; j < DIM; ++j) {
    if (self || j != y) {
      col.add(x * DIM + j);
    }
  }

  var startX = x - x % 3;
  var startY = y - y % 3;

  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      if (self || ((i + startX) * DIM != x && (j + startY) != y)) {
        subgrid.add((i + startX) * DIM + (j + startY));
      }
    }
  }

  return {'row': row, 'col': col, 'sub': subgrid};
}
