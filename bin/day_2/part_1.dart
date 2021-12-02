import 'dart:math';
import 'util.dart';

void main() async {
  final instructions = await getInstructions();

  final endPosition = instructions.fold<Point>(
      Point(0, 0),
      (result, instruction) =>
          result +
          (instruction.direction.isHorizontal
              ? Point(instruction.amount, 0)
              : Point(
                  0, instruction.amount * instruction.direction.yMultiplier)));

  print(endPosition.x * endPosition.y);
}
