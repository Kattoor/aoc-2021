import 'util.dart';

final Map<String, int> syntaxErrorScoreMapping = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137
};

void main() async {
  final lines = await getLines();
  final syntaxErrorScore =
      lines.fold<int>(0, (cumSum, line) => cumSum + parse(line));
  print(syntaxErrorScore);
}

int parse(String input) {
  List<String> chars = input.split('');
  List<String> openCharStack = [];
  for (var char in chars) {
    if (openChars.contains(char)) {
      openCharStack.add(char);
    } else {
      final openCharForThisCloseChar = openCharStack.removeLast();
      final expectedCloseChar = chunkChars[openCharForThisCloseChar];
      if (char != expectedCloseChar) {
        return syntaxErrorScoreMapping[char]!;
      }
    }
  }
  return 0;
}
