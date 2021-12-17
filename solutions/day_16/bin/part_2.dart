import 'util.dart';

void main() async {
  final hex = await getInput();
  final binary = hexToBinary(hex).split('');

  Packet rootPacket = Packet.read(binary);

  print(rootPacket.content.getValue());
}
