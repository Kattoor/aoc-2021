import 'util.dart';

final Map<String, int> syntaxErrorScoreMapping = {
  '(': 1,
  '[': 2,
  '{': 3,
  '<': 4
};

void main() async {
  final lines = await getLines();

  final incompleteLines = lines
      .map(parse)
      .where((parseResult) => !parseResult.isCorrupted)
      .toList();

  final lineScores = incompleteLines.map((parseResult) {
    final openStack = parseResult.remainingOpenCharsStack;
    var sum = 0;
    while (openStack.isNotEmpty) {
      sum = sum * 5 + syntaxErrorScoreMapping[openStack.removeLast()]!;
    }
    return sum;
  }).toList();

  lineScores.sort();

  print(lineScores[lineScores.length ~/ 2]);
}

class ParseResult {
  final bool isCorrupted;
  final List<String> remainingOpenCharsStack;

  ParseResult(this.isCorrupted, [this.remainingOpenCharsStack = const []]);
}

ParseResult parse(String input) {
  List<String> chars = input.split('');
  List<String> openCharStack = [];
  for (var char in chars) {
    if (openChars.contains(char)) {
      openCharStack.add(char);
    } else {
      final openCharForThisCloseChar = openCharStack.removeLast();
      final expectedCloseChar = chunkChars[openCharForThisCloseChar];
      if (char != expectedCloseChar) {
        return ParseResult(true);
      }
    }
  }
  return ParseResult(false, openCharStack);
}
