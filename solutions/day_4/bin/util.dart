import 'dart:io';

class Cell {
  final int number;
  late bool drawn = false;

  Cell(this.number);
}

class Row {
  final List<Cell> cells;

  Row(this.cells);

  checkForNumber(int number) {
    for (var cell in cells) {
      if (cell.number == number) {
        cell.drawn = true;
        //break;
      }
    }
  }

  hasBingo() {
    return cells.every((cell) => cell.drawn);
  }

  List<int> getNotDrawnNumbers() {
    return cells
        .where((cell) => !cell.drawn)
        .map((cell) => cell.number)
        .toList();
  }
}

class Board {
  final int boardNumber;

  final List<Row> rows;

  Board(this.boardNumber, this.rows);

  checkForNumber(int number) {
    for (var row in rows) {
      row.checkForNumber(number);
    }
  }

  hasBingo() {
    /* Check rows */
    for (var row in rows) {
      if (row.hasBingo()) {
        return true;
      }
    }

    /* Check columns */
    final amountOfColumns = rows.first.cells.length;
    for (var i = 0; i < amountOfColumns; i++) {
      final column = [for (var row in rows) row.cells[i]];
      if (column.every((cell) => cell.drawn)) {
        return true;
      }
    }

    return false;
  }

  int getScore() => rows
      .map((row) => row.getNotDrawnNumbers())
      .expand((rowCells) => rowCells)
      .fold(0, (cumSum, cell) => cumSum + cell);
}

List<List<Row>> groupPer5(List<Row> rows) {
  return [
    for (int i = 0; i < (rows.length / 5).ceil(); i += 1)
      rows.sublist(i * 5, i * 5 + 5)
  ];
}

Future<List<Board>> getBoards() async {
  final input = await File('../../assets/inputs/day_4.txt').readAsString();

  final rows = RegExp(r'^((?: *\d+){5})$', multiLine: true)
      .allMatches(input)
      .map((m) => Row(RegExp(r' *(\d+)')
          .allMatches(m.group(0)!)
          .map((m) => Cell(int.parse(m.group(0)!)))
          .toList()))
      .toList();

  final boards = groupPer5(rows)
      .asMap()
      .entries
      .map((entry) => Board(entry.key + 1, entry.value));

  return boards.toList();
}

Future<List<int>> getNumbers() async =>
    (await File('../../assets/inputs/day_4.txt').readAsLines())
        .first
        .split(',')
        .map(int.parse)
        .toList();
