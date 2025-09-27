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
      phone: fields[2] as int?,
      password: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Donor obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.password);
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
      phone: fields[2] as int?,
      password: fields[3] as String?,
      profilePhotoPath: fields[6] as String?,
      vehicleType: fields[4] as String?,
      capacity: fields[5] as int?,
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
      ..write(obj.vehicleType)
      ..writeByte(5)
      ..write(obj.capacity)
      ..writeByte(6)
      ..write(obj.profilePhotoPath);
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
