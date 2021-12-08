import 'dart:io';

enum Position { a, b, c, d, e, f, g }

class SignalPattern {
  late List<String> signal;

  SignalPattern.fromString(String str) {
    signal = str.split('');
  }
}

class Record {
  late List<SignalPattern> signalPatterns;
  late List<SignalPattern> outputValues;

  Record.fromLine(String line) {
    final chunks = line.split(' | ');
    signalPatterns = extractSignalPatterns(chunks[0]);
    outputValues = extractSignalPatterns(chunks[1]);
  }

  extractSignalPatterns(String line) {
    return line.split(' ').map((str) => SignalPattern.fromString(str)).toList();
  }
}

Future<List<Record>> getRecords() async {
  final inputLines = await File('../../assets/inputs/day_8.txt').readAsLines();
  return inputLines.map((line) => Record.fromLine(line)).toList();
}

bool isValid(List<String> changedSignalPatterns, String number) {
  final indexOfNumber = changedSignalPatterns.indexOf(number);
  if (indexOfNumber == -1) {
    return false;
  }
  changedSignalPatterns.removeAt(indexOfNumber);
  return true;
}

List<String> mapSignalPatterns(
  List<SignalPattern> originalSignalPatterns,
  Map<String, String> mapping,
) {
  return originalSignalPatterns.map((pattern) {
    final changedSignals = pattern.signal.map((char) => mapping[char]).toList();
    changedSignals.sort();
    return changedSignals.join();
  }).toList();
}

bool isCorrectMapping(
  Record record,
  Map<String, String> possibility,
  Map<int, String> numbers,
) {
  final mappedSignalPatterns =
      mapSignalPatterns(record.signalPatterns, possibility);

  for (var i = 0; i < 10; i++) {
    if (!isValid(mappedSignalPatterns, numbers[i]!)) {
      return false;
    }
  }

  return true;
}

List<int> getMappedOutputValues(
    Record record, Map<String, String> possibility, Map<int, String> numbers) {
  final mappedSignalPatterns =
      mapSignalPatterns(record.outputValues, possibility);

  return mappedSignalPatterns.map((signal) {
    for (var i = 0; i < numbers.length; i++) {
      if (signal == numbers[i]) {
        return i;
      }
    }
    return -1;
  }).toList();
}

List<int> convert(
  Record record,
  List<Map<String, String>> possibilities,
  Map<int, String> numbers,
) {
  for (var possibility in possibilities) {
    if (!isCorrectMapping(record, possibility, numbers)) {
      continue;
    }

    return getMappedOutputValues(record, possibility, numbers);
  }

  return [];
}

/* Get a list of all possible signal pattern mappings */
List<Map<String, String>> permute(List<Position> defaultPositions) {
  List<Map<String, String>> results = [];

  void permute(List<Position> positions, List<Position> m) {
    if (positions.isEmpty) {
      results.add(Map.fromEntries([
        for (var i = 0; i < defaultPositions.length; i += 1)
          MapEntry(
            defaultPositions[i].toString().split('.')[1],
            m[i].toString().split('.')[1],
          )
      ]));
    } else {
      for (var i = 0; i < positions.length; i++) {
        final current = List.of(positions);
        final next = current.removeAt(i);
        permute(List.of(current), List.of(m)..add(next));
      }
    }
  }

  permute(defaultPositions, []);

  return results;
}
