import 'dart:math';

import 'util.dart';

late Map<String, int> insertionPairCounter;
late Map<String, int> characterCounter = {};

void main() async {
  final input = await getInput();

  final polymerTemplate = input.polymerTemplate;
  final insertionPairs = input.insertionPairs;

  insertionPairCounter =
      Map.fromEntries(insertionPairs.keys.map((key) => MapEntry(key, 0)));
  for (final char in polymerTemplate.split('')) {
    characterCounter.update(char, (value) => value + 1, ifAbsent: () => 1);
  }

  final chunks = zipWithSelfSkip1(polymerTemplate);

  for (final chunk in chunks) {
    insertionPairCounter.update(chunk, (value) => value + 1);
  }

  for (var i = 0; i < 10; i += 1) {
    step(insertionPairs);
  }

  final maxValue =
      characterCounter.entries.map((entry) => entry.value).reduce(max);
  final minValue =
      characterCounter.entries.map((entry) => entry.value).reduce(min);

  print(maxValue - minValue);
}

void step(Map<String, String> insertionPairs) {
  final Map<String, int> tempInsertionPairCounter = {};

  insertionPairCounter.forEach((pair, count) {
    final insertionPairMapping = insertionPairs[pair]!;

    final pairChars = pair.split('');
    final part1 = pairChars.first + insertionPairMapping;
    final part2 = insertionPairMapping + pairChars.last;

    characterCounter.update(insertionPairMapping, (value) => value + count,
        ifAbsent: () => count);
    tempInsertionPairCounter.update(part1, (value) => value + count,
        ifAbsent: () => count);
    tempInsertionPairCounter.update(part2, (value) => value + count,
        ifAbsent: () => count);
  });

  insertionPairCounter = tempInsertionPairCounter;
}
