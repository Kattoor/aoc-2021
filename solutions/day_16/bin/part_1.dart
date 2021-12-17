import 'util.dart';

void main() async {
  final hex = await getInput();
  final binary = hexToBinary(hex).split('');

  Packet rootPacket = Packet.read(binary);

  int packetVersionCumSum = 0;

  List<Packet> packets = [rootPacket];
  while (packets.isNotEmpty) {
    final Packet packet = packets.removeLast();
    packetVersionCumSum += packet.header.version;

    final packetContent = packet.content;
    if (packetContent is ContainerPacketContent) {
      packets.addAll(packetContent.subPackets);
    }
  }

  print(packetVersionCumSum);
}
