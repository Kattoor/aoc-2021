import 'dart:io';

Future<List<String>> getLines() async {
  return await File('../../assets/inputs/day_10.txt').readAsLines();
}

final Map<String, String> chunkChars = {'(': ')', '{': '}', '[': ']', '<': '>'};
final List<String> openChars = chunkChars.keys.toList();
