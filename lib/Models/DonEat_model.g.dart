// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DonEat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DonorAdapter extends TypeAdapter<Donor> {
  @override
  final int typeId = 0;

  @override
  Donor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Donor(
      name: fields[0] as String?,
      email: fields[1] as String?,
      phone: fields[2] as String?,
      password: fields[3] as String?,
      profilePhotoPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Donor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.profilePhotoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentAdapter extends TypeAdapter<Agent> {
  @override
  final int typeId = 1;

  @override
  Agent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Agent(
      name: fields[0] as String?,
      email: fields[1] as String?,
      phone: fields[2] as String?,
      password: fields[3] as String?,
      profilePhotoPath: fields[4] as String?,
      vehicleType: fields[5] as String?,
      capacity: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Agent obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.profilePhotoPath)
      ..writeByte(5)
      ..write(obj.vehicleType)
      ..writeByte(6)
      ..write(obj.capacity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DonationAdapter extends TypeAdapter<Donation> {
  @override
  final int typeId = 2;

  @override
  Donation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Donation(
      foodName: fields[0] as String?,
      location: fields[1] as String?,
      date: fields[2] as String?,
      time: fields[3] as String?,
      contact: fields[4] as String?,
      quantity: fields[5] as int?,
      imagePaths: (fields[6] as List?)?.cast<String>(),
      donationId: fields[7] as String?,
      status: fields[8] as String?,
      acceptedByAgentId: fields[9] as String?,
      donorId: fields[10] as String?,
      donorEmail: fields[11] as String?,
      agentEmail: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Donation obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.foodName)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.contact)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.imagePaths)
      ..writeByte(7)
      ..write(obj.donationId)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.acceptedByAgentId)
      ..writeByte(10)
      ..write(obj.donorId)
      ..writeByte(11)
      ..write(obj.donorEmail)
      ..writeByte(12)
      ..write(obj.agentEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 3;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      donationId: fields[0] as String?,
      senderId: fields[1] as String?,
      message: fields[2] as String?,
      timestamp: fields[3] as DateTime?,
      senderName: fields[4] as String?,
      senderType: fields[5] as String?,
      senderEmail: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.donationId)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.senderName)
      ..writeByte(5)
      ..write(obj.senderType)
      ..writeByte(6)
      ..write(obj.senderEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
