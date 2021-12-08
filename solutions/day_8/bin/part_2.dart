import 'util.dart';

final numbers = {
  0: 'abcdeg',
  1: 'ab',
  2: 'acdfg',
  3: 'abcdf',
  4: 'abef',
  5: 'bcdef',
  6: 'bcdefg',
  7: 'abd',
  8: 'abcdefg',
  9: 'abcdef'
};

void main() async {
  final records = await getRecords();

  final possibilities = permute(Position.values);

  final results =
      records.map((record) => convert(record, possibilities, numbers));

  final answer = results.fold<int>(
      0, (cumSum, result) => cumSum + int.parse(result.join()));

  print(answer);
}
