import 'dart:io';

class Node {
  final String name;
  late bool isSmallCave;
  bool alreadyVisited = false;
  final List<Node> neighbours;

  Node(this.name, this.neighbours) {
    isSmallCave = isSmall(name);
  }

  static bool isSmall(String nodeName) {
    return nodeName.toLowerCase() == nodeName;
  }
}

/*class Edge {
  late Node n1;
  late Node n2;

  Edge(this.n1, this.n2);
}*/

Future<Map<String, Node>> getCaveSystem() async {
  final lines = await File('../../assets/inputs/day_12.txt').readAsLines();

  final Map<String, Node> nodes = {};

  for (final line in lines) {
    final parts = line.split('-');

    final node1Name = parts[0];
    final node2Name = parts[1];

    final node1 = nodes.putIfAbsent(node1Name, () => Node(node1Name, []));
    final node2 = nodes.putIfAbsent(node2Name, () => Node(node2Name, []));

    node1.neighbours.add(node2);
    node2.neighbours.add(node1);
  }

  return nodes;
}
