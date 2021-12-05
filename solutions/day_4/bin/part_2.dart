import 'util.dart';

void main() async {
  final boards = await getBoards();
  final numbers = await getNumbers();

  Board? lastBoardToWin;
  int? lastDrawnNumber;

  for (var i = 0; i < numbers.length; i++) {
    var number = numbers[i];
    lastDrawnNumber = number;

    final winningBoardsThisTurn = [];

    for (var board in boards) {
      board.checkForNumber(number);

      if (board.hasBingo()) {
        winningBoardsThisTurn.add(board);
        lastBoardToWin = board;
      }
    }

    boards.removeWhere((board) => winningBoardsThisTurn.contains(board));

    if (boards.isEmpty) {
      break;
    }
  }

  print('Board ' + lastBoardToWin!.boardNumber.toString() + ' won!');
  print('Score: ' + (lastBoardToWin.getScore() * lastDrawnNumber!).toString());
}
