import 'util.dart';

final Map<int, int> cache = {};

class Fish {
  final int daysUntilFishCanGiveBirth;

  Fish(this.daysUntilFishCanGiveBirth);
}

int calculateNumberOfDirectDescendantsForFish(
    daysUntilEndOfSimulation, daysUntilFishCanGiveBirth) {
  var result = 0;

  if (daysUntilEndOfSimulation - daysUntilFishCanGiveBirth > 0) {
    result = ((daysUntilEndOfSimulation + 6 - daysUntilFishCanGiveBirth) / 7)
        .floor();
  }

  return result;
}

int calculateNumberOfDescendantFishesRecursively(
    int daysLeft, List<Fish> fishes) {
  return fishes.fold(0, (cumSum, fish) {
    final daysUntilFishCanGiveBirth = fish.daysUntilFishCanGiveBirth;

    var counter = 0;

    final numberOfDirectDescendantsForFish =
        calculateNumberOfDirectDescendantsForFish(
            daysLeft, daysUntilFishCanGiveBirth);

    counter += numberOfDirectDescendantsForFish;

    var descendantFishes = [
      for (var i = 0; i < numberOfDirectDescendantsForFish; i++)
        Fish(7 * (i + 1) + 2)
    ];

    final nextIterationDaysLeft = daysLeft - daysUntilFishCanGiveBirth;
    descendantFishes = descendantFishes.where((fish) {
      var cacheHit =
          cache[nextIterationDaysLeft - fish.daysUntilFishCanGiveBirth];
      if (cacheHit != null) {
        counter += cacheHit;
        return false;
      }

      return true;
    }).toList();

    counter += calculateNumberOfDescendantFishesRecursively(
        nextIterationDaysLeft, descendantFishes);

    if (cache[daysLeft - daysUntilFishCanGiveBirth] == null) {
      cache[daysLeft - daysUntilFishCanGiveBirth] = counter;
    }

    return cumSum + counter;
  });
}

void main() async {
  var internalTimers = await getInternalTimers();
  final amountOfDays = 256;

  print(internalTimers.length +
      calculateNumberOfDescendantFishesRecursively(
          amountOfDays,
          internalTimers
              .map((daysUntilFishCanGiveBirth) =>
                  Fish(daysUntilFishCanGiveBirth))
              .toList()));
}
