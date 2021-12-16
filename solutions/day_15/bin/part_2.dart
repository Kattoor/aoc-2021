import 'dart:math';

import 'package:collection/collection.dart';

import 'util.dart';

late List<Cell> cells;

final frontier = PriorityQueue<Cell>((c1, c2) => c1.cost.compareTo(c2.cost));

void main() async {
  cells = await getCells(shouldSetNeighbours: false);

  await extendGrid();

  final Cell origin = cells.first
    ..visited = true
    ..cost = 0;
  final Cell destination = cells.last;
  frontier.add(origin);

  while (frontier.isNotEmpty) {
    final Cell current = frontier.removeFirst();

    if (current == destination) {
      break;
    }

    for (final neighbour in current.unvisitedNeighbours) {
      neighbour.visited = true;

      final newCost = current.cost + neighbour.value;
      if (newCost < neighbour.cost) {
        neighbour.cost = newCost;
        neighbour.cameFrom = current;
        frontier.add(neighbour);
      }
    }
  }

  print(destination.cost.toInt());
}

Future extendGrid() async {
  Point<int> dimensions = await getDimensions();
  List<Cell> newCells = [];

  /* Right */
  for (var y = 0; y < dimensions.y; y++) {
    for (var x = 0; x < dimensions.x; x++) {
      newCells.add(cells[y * dimensions.x + x]);
    }

    for (var i = 1; i < 5; i++) {
      for (var x = 0; x < dimensions.x; x++) {
        Cell cell = cells[y * dimensions.x + x];
        final cellCopy = Cell(
            getNewCellValue(cell, i), cell.x + dimensions.x * i, cell.y, []);
        newCells.add(cellCopy);
      }
    }
  }

  dimensions = Point(dimensions.x * 5, dimensions.y);

  /* Down */
  for (var i = 1; i < 5; i++) {
    for (var y = 0; y < dimensions.y; y++) {
      for (var x = 0; x < dimensions.x; x++) {
        Cell cell = newCells[y * dimensions.x + x];

        final cellCopy = Cell(
            getNewCellValue(cell, i), cell.x, cell.y + dimensions.y * i, []);
        newCells.add(cellCopy);
      }
    }
  }

  cells = newCells;

  dimensions = Point(dimensions.x, dimensions.y * 5);

  for (var y = 0; y < dimensions.y; y++) {
    for (var x = 0; x < dimensions.x; x++) {
      setNeighbours(x, y, dimensions.x, dimensions.y, cells);
    }
  }
}

int getNewCellValue(Cell cell, int i) {
  var newCellValue = cell.value + i;
  return newCellValue > 9 ? newCellValue - 9 : newCellValue;
}
