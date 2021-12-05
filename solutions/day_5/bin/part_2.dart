import 'util.dart';

void main() async {
  final lines = await getLines();
  final oceanFloor = getOceanFloor(lines, takeDiagonalLinesIntoAccount: true);
  print(oceanFloor.amountOfDangerousAreas);
}
