import 'util.dart';

void main() async {
  final diagnosticReadings = await getDiagnosticReadings();

  final oneAndZeroCounts = getOneAndZeroCounts(diagnosticReadings);

  final mostCommonBits = getMostCommonBits(oneAndZeroCounts);

  final gammaRate = int.parse(mostCommonBits.join(), radix: 2);

  final epsilonRate =
      int.parse(mostCommonBits.map((bit) => 1 - bit).join(), radix: 2);

  print(gammaRate * epsilonRate);
}
