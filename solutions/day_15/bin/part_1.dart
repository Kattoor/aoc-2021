import 'package:collection/collection.dart';

import 'util.dart';

late List<Cell> cells;

final frontier = PriorityQueue<Cell>((c1, c2) => c1.cost.compareTo(c2.cost));

void main() async {
  cells = await getCells();

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
