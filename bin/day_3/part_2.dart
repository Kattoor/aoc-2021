import 'util.dart';

void main() async {
  final diagnosticReadings = await getDiagnosticReadings();

  final oxygenGeneratorRating =
      getRating(diagnosticReadings, (e) => getMostCommonBits(e).first);

  final co2ScrubberRating =
      getRating(diagnosticReadings, (e) => 1 - getMostCommonBits(e).first);

  final lifeSupportRating = oxygenGeneratorRating * co2ScrubberRating;

  print(lifeSupportRating);
}
