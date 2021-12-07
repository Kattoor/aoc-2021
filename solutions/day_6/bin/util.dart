import 'dart:io';

Future<List<int>> getInternalTimers() async {
  final input = await File('../../assets/inputs/day_6.txt').readAsString();
  return input.split(',').map(int.parse).toList();
}
