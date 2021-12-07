import 'dart:math';

import 'util.dart';

void main() async {
  final horizontalPositions = await getHorizontalPositions();

  final minPosition = horizontalPositions.reduce(min);
  final maxPosition = horizontalPositions.reduce(max);

  final positionsToCheck = [
    for (var i = minPosition; i < maxPosition; i += 1) i
  ];

  final positionWithLeastAmountOfFuelNeeded = positionsToCheck
      .map((position) => PositionAndFuelNeeded(
          position,
          calculateFuelUsageForPositionAtConstantRate(
              horizontalPositions, position)))
      .reduce((e1, e2) => e1.fuelNeeded < e2.fuelNeeded ? e1 : e2);

  print(positionWithLeastAmountOfFuelNeeded.fuelNeeded);
}
