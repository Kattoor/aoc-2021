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

  final sumOfRiskLevels = lowPoints.fold<int>(0, (cumSum, current) => cumSum + current.height + 1);

  print(sumOfRiskLevels);
}
