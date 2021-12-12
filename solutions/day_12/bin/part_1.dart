import 'util.dart';

late Map<String, Node> nodes;
final List<List<Node>> paths = [];

void main() async {
  nodes = await getCaveSystem();
  travelPath(nodes['start']!, nodes['end']!, [nodes['start']!], []);
  print(paths.length);
}

void travelPath(Node current, Node destination, List<Node> visited,
    List<Node> traveledPath) {
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

    travelPath(neighbour, destination, visitedCopy, traveledPathCopy);
  }
}
