import 'util.dart';

void main() async {
  final lines = await getLines();
  final oceanFloor = getOceanFloor(lines);
  print(oceanFloor.amountOfDangerousAreas);
}
