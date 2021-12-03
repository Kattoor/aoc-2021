import 'dart:io';

class OneZeroCount {
  final int zero;
  final int one;

  OneZeroCount(this.zero, this.one);
}

Future<List<List<int>>> getDiagnosticReadings() async =>
    (await File('./assets/inputs/day_3.txt').readAsLines())
        .map((line) => line.split('').map(int.parse).toList())
        .toList();

List<OneZeroCount> getOneAndZeroCounts(List<List<int>> diagnosticReadings) =>
    diagnosticReadings.fold<List<OneZeroCount>>(
        [
          for (var i = 0; i < diagnosticReadings.first.length; i += 1)
            OneZeroCount(0, 0)
        ],
        (values, current) => current
            .asMap()
            .entries
            .map((entry) => OneZeroCount(
                values[entry.key].zero + (1 - entry.value),
                values[entry.key].one + entry.value))
            .toList());

List<int> getMostCommonBits(List<OneZeroCount> oneZeroCounts) => oneZeroCounts
    .map((oneZeroCount) => oneZeroCount.one >= oneZeroCount.zero ? 1 : 0)
    .toList();

int getRating(List<List<int>> diagnosticReadings,
    Function(List<OneZeroCount>) getFilterBit) {
  var readings = [...diagnosticReadings];
  for (var i = 0; i < readings.first.length; i += 1) {
    final bytesAtCurrentIndex = readings.map((bytes) => [bytes[i]]).toList();
    final oneAndZeroCounts = getOneAndZeroCounts(bytesAtCurrentIndex);
    final filterBit = getFilterBit(oneAndZeroCounts);
    readings = readings.where((bytes) => bytes[i] == filterBit).toList();
    if (readings.length == 1) {
      break;
    }
  }
  return int.parse(readings.first.join(), radix: 2);
}
