import 'util.dart';

final numbers = {
  0: 'abcefg',
  1: 'cf',
  2: 'acdeg',
  3: 'acdfg',
  4: 'bcdf',
  5: 'abdfg',
  6: 'abdefg',
  7: 'acf',
  8: 'abcdefg',
  9: 'abcdfg'
};

void main() async {
  final records = await getRecords();

  final possibilities = permute(Position.values);

  final results =
      records.map((record) => convert(record, possibilities, numbers));

  final answer = results.fold<int>(
      0,
      (cumSum, result) =>
          cumSum +
          result
              .where((clockValue) => [1, 4, 7, 8].contains(clockValue))
              .length);

  print(answer);
}
