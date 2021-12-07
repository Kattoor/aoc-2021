import 'dart:io';

class PositionAndFuelNeeded {
  final int position;
  final int fuelNeeded;

  PositionAndFuelNeeded(this.position, this.fuelNeeded);
}

Future<List<int>> getHorizontalPositions() async {
  final input = await File('../../assets/inputs/day_7.txt').readAsString();
  return input.split(',').map(int.parse).toList();
}

int calculateFuelUsageForPositionAtConstantRate(
    List<int> crabPositions, int x) {
  return crabPositions
      .map((position) => (position - x).abs())
      .fold(0, (cumSum, delta) => cumSum + delta);
}

int calculateFuelUsageForPositionAtIncreasingRate(
    List<int> crabPositions, int x) {
  return crabPositions.map((position) {
    final delta = (position - x).abs();
    /*
    * Searched for the name of the following formula, it's the 'nth triangular number'
    * https://math.stackexchange.com/a/60581
    * */
    return delta * (delta + 1) / 2;
  }).fold(0, (cumSum, delta) => (cumSum + delta).toInt());
}
