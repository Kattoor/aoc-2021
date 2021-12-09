import 'util.dart';

late List<List<Cell>> heightMap;
late int width;
late int height;

void main() async {
  heightMap = await getHeightMap();
  height = heightMap.length;
  width = heightMap.first.length;

  final Set<Cell> lowPoints = {};
  for (final row in heightMap) {
    for (final cell in row) {
      final lowPoint = getLowPointForCell(cell, heightMap, width, height);
      if (lowPoint != null) {
        lowPoints.add(lowPoint);
      }
    }
  }

  final Map<Cell, List<Cell>> basins = heightMap.expand((row) => row).fold(
      <Cell, List<Cell>>{}, (groups, cell) {
    if (cell.height != 9) {
      if (!groups.containsKey(cell.adjacentLowPoint)) {
        groups[cell.adjacentLowPoint!] = List<Cell>.from([cell]);
      } else {
        groups[cell.adjacentLowPoint]!.add(cell);
      }
    }

    return groups;
  });

  final basinEntries = basins.entries.toList();
  basinEntries.sort((basinEntry1, basinEntry2) => basinEntry2.value.length - basinEntry1.value.length);

  final threeLargestBasins = basinEntries.take(3).toList();

  print(threeLargestBasins.fold<int>(1, (cumSum, basinEntry) => cumSum * basinEntry.value.length));
}
