import 'util.dart';

void main() async {
  final input = await getInput();
  var points = input.points;
  var foldInstructions = input.foldInstructions;

  points = fold(points, foldInstructions.first);

  print(Set.of(points).length);
}
