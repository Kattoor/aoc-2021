import 'dart:io';

Future<List<int>> getDepthReadings() async {
  return (await File('../../assets/inputs/day_1.txt').readAsLines())
      .map(int.parse)
      .toList();
}

List<List<int>> zipWithSelfSkip1(List<int> list) {
  return [
    for (int i = 0; i < list.length - 1; i += 1) [list[i], list[i + 1]]
  ];
}
