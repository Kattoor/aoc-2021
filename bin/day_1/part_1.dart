import 'util.dart';

void main() async {
  final depthReadings = await getDepthReadings();

  final groups = zipWithSelfSkip1(depthReadings);

  print(groups.fold<int>(
      0, (count, readings) => readings[1] > readings[0] ? count + 1 : count));
}
