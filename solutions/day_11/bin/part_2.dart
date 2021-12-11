import 'util.dart';

late Grid grid;

void main() async {
  grid = await getGrid();

  int stepCounter = 0;
  bool reachedSynchronizedFlash = false;

  while (!reachedSynchronizedFlash) {
    reachedSynchronizedFlash = step();
    stepCounter += 1;
  }

  print(stepCounter);
}

bool step() {
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

  int flashCount = 0;
  for (var row in grid.rows) {
    for (var octopus in row) {
      if (octopus.flashedThisStep) {
        octopus.flashedThisStep = false;
        octopus.energyLevel = 0;
        flashCount += 1;
      }
    }
  }

  return flashCount == grid.rows.length * grid.rows.first.length;
}
