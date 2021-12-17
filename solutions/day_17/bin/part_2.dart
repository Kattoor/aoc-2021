import 'dart:math';

import 'util.dart';

late Point<int> topLeft;
late Point<int> bottomRight;

void main() async {
  final targetArea = await getTargetArea();
  topLeft = targetArea.topLeft;
  bottomRight = targetArea.bottomRight;

  final List<ShotResult> hits = [];

  for (var y = -1000; y < 1000; y++) {
    for (var x = -1000; x < 1000; x++) {
      final shot = shoot(Point(x, y), topLeft, bottomRight);
      if (shot.hit) {
        hits.add(shot);
      }
    }
  }

  print(hits.length);
}
