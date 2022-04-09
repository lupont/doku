import 'main.dart';

bool isFinished(List<int?> board) {
  return board.every((cell) => cell != null);
}

bool isValid(int subject, int index, List<int?> board) {
  int y = index % DIM;
  int x = index ~/ DIM;

  var buddies = getBuddies(x, y)!;

  var row = buddies['row']!.map((i) => board[i]).toList();
  var col = buddies['col']!.map((i) => board[i]).toList();
  var sub = buddies['sub']!.map((i) => board[i]).toList();

  return !row.contains(subject) &&
      !col.contains(subject) &&
      !sub.contains(subject);
}

Map<String, List<int>>? getBuddies(int x, int y) {
  if (x < 0 || y < 0 || x >= DIM || y >= DIM) {
    return null;
  }

  List<int> row = [];
  List<int> col = [];
  List<int> subgrid = [];

  for (int i = 0; i < DIM; ++i) {
    if (i * DIM != x) {
      row.add(i * DIM + y);
    }
  }

  for (int j = 0; j < DIM; ++j) {
    if (j != y) {
      col.add(x * DIM + j);
    }
  }

  var startX = x - x % 3;
  var startY = y - y % 3;

  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      if ((i + startX) * DIM != x && (j + startY) != y) {
        subgrid.add((i + startX) * DIM + (j + startY));
      }
    }
  }

  return {'row': row, 'col': col, 'sub': subgrid};
}
