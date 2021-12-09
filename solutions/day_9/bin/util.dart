import 'dart:collection';
import 'dart:io';

class Cell {
  final int x;
  final int y;
  final int height;

  Cell? adjacentLowPoint;

  Cell(this.x, this.y, this.height);
}

Future<List<List<Cell>>> getHeightMap() async {
  final inputLines = await File('../../assets/inputs/day_9.txt').readAsLines();
  return inputLines
      .asMap()
      .entries
      .map((lineEntry) => lineEntry.value
          .split('')
          .asMap()
          .entries
          .map((cellEntry) =>
              Cell(cellEntry.key, lineEntry.key, int.parse(cellEntry.value)))
          .toList())
      .toList();
}

Cell? getLowPointForCell(
    Cell cell, List<List<Cell>> heightMap, int width, int height) {
  cell.adjacentLowPoint = cell;

  final visitedCells = [cell];
  final cellsToCheck = Queue<CellToCheck>();

  addNeighboursToQueue(heightMap, width, height, cellsToCheck, cell);

  final neighbourHeights =
      cellsToCheck.map((neighbour) => neighbour.cell.height);

  if (neighbourHeights.every((height) => height == cell.height)) {
    return null;
  }

  while (cellsToCheck.isNotEmpty) {
    final cellToCheck = cellsToCheck.removeFirst();

    visitedCells.add(cellToCheck.cell);

    if (cellToCheck.cell.height < cell.adjacentLowPoint!.height) {
      if (cellToCheck.cell.adjacentLowPoint != null) {
        cell.adjacentLowPoint = cellToCheck.cell.adjacentLowPoint!;
        break;
      }

      cell.adjacentLowPoint = cellToCheck.cell;
      addNeighboursToQueue(
          heightMap, width, height, cellsToCheck, cellToCheck.cell,
          excludedDirection: cellToCheck.previousCellDirection);
    }
  }
  return cell.adjacentLowPoint;
}

class CellToCheck {
  final Cell cell;
  final Direction previousCellDirection;

  CellToCheck(this.cell, this.previousCellDirection);
}

void addNeighboursToQueue(List<List<Cell>> heightMap, int width, int height,
    Queue<CellToCheck> queue, Cell currentCell,
    {Direction? excludedDirection}) {
  if (excludedDirection != Direction.left && currentCell.x > 0) {
    queue.add(CellToCheck(
        heightMap[currentCell.y][currentCell.x - 1], Direction.right));
  }

  if (excludedDirection != Direction.right && currentCell.x < width - 1) {
    queue.add(CellToCheck(
        heightMap[currentCell.y][currentCell.x + 1], Direction.left));
  }

  if (excludedDirection != Direction.up && currentCell.y > 0) {
    queue.add(CellToCheck(
        heightMap[currentCell.y - 1][currentCell.x], Direction.down));
  }

  if (excludedDirection != Direction.down && currentCell.y < height - 1) {
    queue.add(
        CellToCheck(heightMap[currentCell.y + 1][currentCell.x], Direction.up));
  }
}

enum Direction { left, up, right, down }
