import 'dart:math';
import 'util.dart';

class PointWithAim {
  final Point point;
  final int aim;

  const PointWithAim(this.point, this.aim);
}

void main() async {
  final instructions = await getInstructions();

  final endPosition = instructions.fold<PointWithAim>(
    PointWithAim(Point(0, 0), 0),
    (result, instruction) => PointWithAim(
      result.point +
          (instruction.direction.isHorizontal
              ? Point(instruction.amount, result.aim * instruction.amount)
              : Point(0, 0)),
      result.aim + (instruction.direction.getAimAddition(instruction.amount)),
    ),
  );

  print(endPosition.point.x * endPosition.point.y);
}
