import 'util.dart';

void main() async {
  var internalTimers = await getInternalTimers();
  final amountOfDays = 80;

  for (var i = 0; i < amountOfDays; i++) {
    internalTimers = internalTimers.expand((timer) {
      final timers = List<int>.empty(growable: true);
      var newTimer = timer - 1;
      if (newTimer == -1) {
        newTimer = 6;
        timers.add(8);
      }
      timers.add(newTimer);
      return timers;
    }).toList();
  }

  print(internalTimers.length);
}
