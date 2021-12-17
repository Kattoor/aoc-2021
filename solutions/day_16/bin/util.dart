import 'dart:io';

import 'dart:math';

Future<String> getInput() async {
  return await File('../../assets/inputs/day_16.txt').readAsString();
}

enum PacketLengthType {
  totalLengthInBits,
  numberOfContainedSubPackets,
}

class Packet {
  late PacketHeader header;
  late PacketContent content;

  int bitsRead = 0;

  late bool printSteps;

  Packet.read(Iterable<String> binary) {
    header = readPacketHeader(binary);
    content = readPacketContent(binary, header.typeId);
  }

  PacketHeader readPacketHeader(Iterable<String> binary) {
    final int version = binaryToInt(binary.skip(bitsRead).take(3));
    bitsRead += 3;

    final int typeId = binaryToInt(binary.skip(bitsRead).take(3));
    bitsRead += 3;

    return PacketHeader(version, typeId);
  }

  PacketContent readPacketContent(Iterable<String> binary, int operator) {
    switch (operator) {
      case 0:
        final packetContent = SumPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      case 1:
        final packetContent = ProductPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      case 2:
        final packetContent = MinimumPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      case 3:
        final packetContent = MaximumPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      case 4:
        final packetContent = LiteralPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      case 5:
        final packetContent = GreaterThanPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      case 6:
        final packetContent = LessThanPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
      default:
        final packetContent = EqualToPacketContent(binary.skip(bitsRead));
        bitsRead += packetContent.bitsRead;
        return packetContent;
    }
  }
}

class PacketHeader {
  final int version;
  final int typeId;

  PacketHeader(this.version, this.typeId);
}

abstract class PacketContent {
  int bitsRead = 0;

  int getValue();
}

String hexToBinary(String hex) {
  Iterable<String> hexChars = hex.split('');
  String binary = '';
  for (final String hexChar in hexChars) {
    binary += int.parse(hexChar, radix: 16).toRadixString(2).padLeft(4, '0');
  }
  return binary;
}

int binaryToInt(Iterable<String> binary) {
  return int.parse(binary.join(), radix: 2);
}

class LiteralPacketContent extends PacketContent {
  late int value;

  LiteralPacketContent(Iterable<String> binary) {
    readLiteral(binary);
  }

  void readLiteral(Iterable<String> binary) {
    final List<Iterable<String>> literalParts = [];

    bool reachedEndOfLiteral = false;

    while (!reachedEndOfLiteral) {
      reachedEndOfLiteral = binary.skip(bitsRead).take(1).first == '0';
      bitsRead += 1;

      literalParts.add(binary.skip(bitsRead).take(4));
      bitsRead += 4;
    }

    value = int.parse(literalParts.map((bits) => bits.join()).join(), radix: 2);
  }

  @override
  int getValue() {
    return value;
  }
}

abstract class ContainerPacketContent extends PacketContent {
  final List<Packet> subPackets = [];

  ContainerPacketContent(Iterable<String> binary) {
    readContainer(binary);
  }

  void readContainer(Iterable<String> binary) {
    int lengthTypeNumber = binaryToInt(binary.skip(bitsRead).take(1));
    bitsRead += 1;

    PacketLengthType lengthType = PacketLengthType.values[lengthTypeNumber];

    switch (lengthType) {
      case PacketLengthType.totalLengthInBits:
        int totalLengthInBits = binaryToInt(binary.skip(bitsRead).take(15));
        bitsRead += 15;

        List<Packet> subPackets =
            readSubPacketsByTotalLengthInBits(totalLengthInBits, binary);

        this.subPackets.addAll(subPackets);
        break;
      case PacketLengthType.numberOfContainedSubPackets:
        int numberOfContainedSubPackets =
            binaryToInt(binary.skip(bitsRead).take(11));
        bitsRead += 11;

        List<Packet> subPackets =
            readSubPacketsByAmount(numberOfContainedSubPackets, binary);

        this.subPackets.addAll(subPackets);
        break;
    }
  }

  List<Packet> readSubPacketsByTotalLengthInBits(
      int totalLengthInBits, Iterable<String> binary) {
    List<Packet> packets = [];

    int offsetAtStart = bitsRead;

    int deltaBitsRead = 0;

    while (deltaBitsRead != totalLengthInBits) {
      final subPacket = Packet.read(binary.skip(bitsRead));
      packets.add(subPacket);
      bitsRead += subPacket.bitsRead;
      deltaBitsRead = bitsRead - offsetAtStart;
    }

    return packets;
  }

  List<Packet> readSubPacketsByAmount(
      int amountOfSubPackets, Iterable<String> binary) {
    List<Packet> packets = [];

    for (var i = 0; i < amountOfSubPackets; i++) {
      final subPacket = Packet.read(binary.skip(bitsRead));
      packets.add(subPacket);
      bitsRead += subPacket.bitsRead;
    }

    return packets;
  }
}

class SumPacketContent extends ContainerPacketContent {
  SumPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    int result = 0;

    for (final Packet subPacket in subPackets) {
      result += subPacket.content.getValue();
    }

    return result;
  }
}

class ProductPacketContent extends ContainerPacketContent {
  ProductPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    int result = 1;

    for (final Packet subPacket in subPackets) {
      result *= subPacket.content.getValue();
    }

    return result;
  }
}

class MinimumPacketContent extends ContainerPacketContent {
  MinimumPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    return subPackets
        .map((subPacket) => subPacket.content.getValue())
        .reduce(min);
  }
}

class MaximumPacketContent extends ContainerPacketContent {
  MaximumPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    return subPackets
        .map((subPacket) => subPacket.content.getValue())
        .reduce(max);
  }
}

class GreaterThanPacketContent extends ContainerPacketContent {
  GreaterThanPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    return subPackets.first.content.getValue() >
            subPackets.last.content.getValue()
        ? 1
        : 0;
  }
}

class LessThanPacketContent extends ContainerPacketContent {
  LessThanPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    return subPackets.first.content.getValue() <
            subPackets.last.content.getValue()
        ? 1
        : 0;
  }
}

class EqualToPacketContent extends ContainerPacketContent {
  EqualToPacketContent(Iterable<String> binary) : super(binary);

  @override
  int getValue() {
    return subPackets.first.content.getValue() ==
            subPackets.last.content.getValue()
        ? 1
        : 0;
  }
}
