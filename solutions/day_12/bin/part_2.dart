import 'util.dart';

late Map<String, Node> nodes;
final List<List<Node>> paths = [];

void main() async {
  nodes = await getCaveSystem();
  travelPath(nodes['start']!, nodes['end']!, [nodes['start']!], [], false);
  print(paths.length);
}

void travelPath(Node current, Node destination, List<Node> visited,
    List<Node> traveledPath, bool smallCaveAlreadyVisitedTwice) {
  final traveledPathCopy = List.of(traveledPath);
  traveledPathCopy.add(current);

  if (current == destination) {
    paths.add(traveledPathCopy);
    return;
  }

  final neighbours = current.neighbours.where(
      (neighbour) => !(neighbour.isSmallCave && visited.contains(neighbour)));

  for (final neighbour in neighbours) {
    final visitedCopy = List.of(visited);

    if (neighbour.isSmallCave) {
      visitedCopy.add(neighbour);
    }

    travelPath(neighbour, destination, visitedCopy, traveledPathCopy,
        smallCaveAlreadyVisitedTwice);
  }

  if (!smallCaveAlreadyVisitedTwice) {
    final secondVisitSmallCaves = current.neighbours.where((neighbour) =>
        neighbour.isSmallCave &&
        visited.contains(neighbour) &&
        !['start', 'end'].contains(neighbour.name));

    for (final neighbour in secondVisitSmallCaves) {
      final visitedCopy = List.of(visited);

      travelPath(neighbour, destination, visitedCopy, traveledPathCopy, true);
    }
  }
}
