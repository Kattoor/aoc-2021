import 'util.dart';

late Grid grid;
int flashCount = 0;

void main() async {
  grid = await getGrid();

  for (var i = 0; i < 100; i++) {
    step();
  }

  print(flashCount);
}

step() {
  for (var row in grid.rows) {
    for (var cell in row) {
      cell.energyLevel += 1;
    }
  }

  for (var row in grid.rows) {
    for (var octopus in row) {
      octopus.checkForFlash(grid);
    }
  }

  for (var row in grid.rows) {
    for (var octopus in row) {
      if (octopus.flashedThisStep) {
        octopus.flashedThisStep = false;
        octopus.energyLevel = 0;
        flashCount += 1;
      }
    }
  }
}
