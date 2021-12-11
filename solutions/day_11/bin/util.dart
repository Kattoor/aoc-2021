import 'dart:io';

class Grid {
  final List<List<Octopus>> rows;

  Grid(this.rows);

  @override
  String toString() => rows.map((line) => line.join(',')).join('\n');
}

class Octopus {
  int energyLevel;
  final int x;
  final int y;
  bool flashedThisStep = false;

  Octopus(this.energyLevel, this.x, this.y);

  List<Octopus> getNeighbours(Grid grid) {
    final List<Octopus> neighbours = [];

    final leftMost = x == 0;
    final rightMost = x == grid.rows.first.length - 1;
    final topMost = y == 0;
    final bottomMost = y == grid.rows.length - 1;

    if (!leftMost) {
      neighbours.add(grid.rows[y][x - 1]);

      if (!topMost) {
        neighbours.add(grid.rows[y - 1][x - 1]);
      }

      if (!bottomMost) {
        neighbours.add(grid.rows[y + 1][x - 1]);
      }
    }

    if (!rightMost) {
      neighbours.add(grid.rows[y][x + 1]);

      if (!topMost) {
        neighbours.add(grid.rows[y - 1][x + 1]);
      }

      if (!bottomMost) {
        neighbours.add(grid.rows[y + 1][x + 1]);
      }
    }

    if (!topMost) {
      neighbours.add(grid.rows[y - 1][x]);
    }

    if (!bottomMost) {
      neighbours.add(grid.rows[y + 1][x]);
    }

    return neighbours;
  }

  void checkForFlash(Grid grid) {
    if (!flashedThisStep && energyLevel > 9) {
      flash(grid);
    }
  }

  void flash(Grid grid) {
    flashedThisStep = true;
    energyLevel = 0;

    final neighbours = getNeighbours(grid);
    for (var neighbour in neighbours) {
      neighbour.energyLevel += 1;
      neighbour.checkForFlash(grid);
    }
  }

  @override
  String toString() {
    return energyLevel.toString();
  }
}

Future<Grid> getGrid() async {
  final lines = await File('../../assets/inputs/day_11.txt').readAsLines();

  final List<List<Octopus>> grid = [];

  for (var y = 0; y < lines.length; y++) {
    final List<Octopus> row = [];
    final values = lines[y].split('').map(int.parse).toList();

    for (var x = 0; x < values.length; x++) {
      row.add(Octopus(values[x], x, y));
    }

    grid.add(row);
  }

  return Grid(grid);
}
