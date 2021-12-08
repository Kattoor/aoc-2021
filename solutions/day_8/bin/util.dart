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

List<int> convert(Record record, List<Map<String, String>> possibilities,
    Map<int, String> numbers) {
  List<SignalPattern> signalPatterns = record.signalPatterns;
  List<SignalPattern> outputValues = record.outputValues;

  for (var possibility in possibilities) {
    final changedSignalPatterns = signalPatterns.map((pattern) {
      final changedSignals =
          pattern.signal.map((char) => possibility[char]).toList();
      changedSignals.sort();
      return changedSignals.join();
    }).toList();

    final indexOfZero = changedSignalPatterns.indexOf(numbers[0]!);
    if (indexOfZero == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfZero);

    final indexOfOne = changedSignalPatterns.indexOf(numbers[1]!);
    if (indexOfOne == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfOne);

    final indexOfTwo = changedSignalPatterns.indexOf(numbers[2]!);
    if (indexOfTwo == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfTwo);

    final indexOfThree = changedSignalPatterns.indexOf(numbers[3]!);
    if (indexOfThree == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfThree);

    final indexOfFour = changedSignalPatterns.indexOf(numbers[4]!);
    if (indexOfFour == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfFour);

    final indexOfFive = changedSignalPatterns.indexOf(numbers[5]!);
    if (indexOfFive == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfFive);

    final indexOfSix = changedSignalPatterns.indexOf(numbers[6]!);
    if (indexOfSix == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfSix);

    final indexOfSeven = changedSignalPatterns.indexOf(numbers[7]!);
    if (indexOfSeven == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfSeven);

    final indexOfEight = changedSignalPatterns.indexOf(numbers[8]!);
    if (indexOfEight == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfEight);

    final indexOfNine = changedSignalPatterns.indexOf(numbers[9]!);
    if (indexOfNine == -1) {
      continue;
    }
    changedSignalPatterns.removeAt(indexOfNine);

    final changedOutputValues = outputValues.map((pattern) {
      final changedSignals =
          pattern.signal.map((char) => possibility[char]).toList();
      changedSignals.sort();
      return changedSignals.join();
    }).toList();

    return changedOutputValues.map((signal) {
      for (var i = 0; i < numbers.length; i++) {
        if (signal == numbers[i]) {
          return i;
        }
      }
      return -1;
    }).toList();
  }

  return [];
}

List<Map<String, String>> permute(List<Position> defaultPositions) {
  List<Map<String, String>> results = [];

  void permute(List<Position> positions, List<Position> m) {
    if (positions.isEmpty) {
      results.add(Map.fromEntries([
        for (var i = 0; i < defaultPositions.length; i += 1)
          MapEntry<String, String>(defaultPositions[i].toString().split('.')[1],
              m[i].toString().split('.')[1])
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
