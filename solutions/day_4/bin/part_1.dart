import 'util.dart';

void main() async {
  final boards = await getBoards();
  final numbers = await getNumbers();

  for (var i = 0; i < numbers.length; i++) {
    var number = numbers[i];

    for (var board in boards) {
      board.checkForNumber(number);

      if (board.hasBingo()) {
        print('Board ' + board.boardNumber.toString() + ' won!');
        print('Score: ' + (board.getScore() * number).toString());
        return;
      }
    }
  }
}
