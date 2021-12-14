import 'dart:io';

class Input {
  final String polymerTemplate;
  final Map<String, String> insertionPairs;

  Input(this.polymerTemplate, this.insertionPairs);
}

Future<Input> getInput() async {
  final lines = await File('../../assets/inputs/day_14.txt').readAsLines();
  final polymerTemplate = lines.first;
  final insertionPairs = Map.fromEntries(lines
      .skip(2)
      .map((line) => line.split(' -> '))
      .map((parts) => MapEntry(parts[0], parts[1])));
  return Input(polymerTemplate, insertionPairs);
}

List<String> zipWithSelfSkip1(String str) {
  final list = str.split('');
  return [
    for (int i = 0; i < list.length - 1; i += 1) str.substring(i, i + 2)
  ];
}
