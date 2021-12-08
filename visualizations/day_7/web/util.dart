import 'package:http/http.dart' as http;

Future<List<int>> getHorizontalPositions() async {
  final client = http.Client();
  final input = (await client.get(Uri.http('localhost:8081', '/inputs/day_7.txt'))).body;
  return input.split(',').map(int.parse).toList();
}

class PositionAndFuelNeeded {
  final int position;
  final int fuelNeeded;

  PositionAndFuelNeeded(this.position, this.fuelNeeded);
}

int calculateFuelUsageForPositionAtIncreasingRate(
    List<int> crabPositions, int x) {
  return crabPositions.map((position) {
    final delta = (position - x).abs();
    return delta * (delta + 1) / 2;
  }).fold(0, (cumSum, delta) => (cumSum + delta).toInt());
}

String getWhaleImageUrl() => 'http://localhost:8081/whale.png';

String getSubmarineImageUrl() => 'http://localhost:8081/submarine.png';

String getCrabSubmarineImageUrl() => 'http://localhost:8081/crabsubmarine.png';
