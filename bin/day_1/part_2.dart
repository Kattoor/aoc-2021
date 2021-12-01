import 'util.dart';

void main() async {
  final depthReadings = await getDepthReadings();

  final windowSums = [
    for (int i = 0; i < depthReadings.length - 2; i += 1)
      depthReadings[i] + depthReadings[i + 1] + depthReadings[i + 2]
  ];

  final groups = zipWithSelfSkip1(windowSums);

  print(groups.fold<int>(
      0, (count, readings) => readings[1] > readings[0] ? count + 1 : count));
}
