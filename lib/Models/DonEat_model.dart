import 'package:hive/hive.dart';

part 'DonEat_model.g.dart';

@HiveType(typeId: 0)
class Donor extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? profilePhotoPath;

  Donor({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.profilePhotoPath,
  });
}

@HiveType(typeId: 1)
class Agent extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? profilePhotoPath;

  @HiveField(5)
  String? vehicleType;

  @HiveField(6)
  int? capacity;

  Agent({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.profilePhotoPath,
    this.vehicleType,
    this.capacity,
  });
}

@HiveType(typeId: 2)
class Donation extends HiveObject {
  @HiveField(0)
  String? foodName;

  @HiveField(1)
  String? location;

  @HiveField(2)
  String? date;

  @HiveField(3)
  String? time;

  @HiveField(4)
  String? contact;

  @HiveField(5)
  int? quantity;

  @HiveField(6)
  List<String>? imagePaths;

  @HiveField(7)
  String? donationId;

  @HiveField(8)
  String? status;

  @HiveField(9)
  String? acceptedByAgentId;

  @HiveField(10)
  String? donorId;

  @HiveField(11)
  String? donorEmail;

  @HiveField(12)
  String? agentEmail;

  Donation({
    this.foodName,
    this.location,
    this.date,
    this.time,
    this.contact,
    this.quantity,
    this.imagePaths,
    this.donationId,
    this.status = 'available',
    this.acceptedByAgentId,
    this.donorId,
    this.donorEmail,
    this.agentEmail,
  });
}

@HiveType(typeId: 3)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String? donationId;

  @HiveField(1)
  String? senderId;

  @HiveField(2)
  String? message;

  @HiveField(3)
  DateTime? timestamp;

  @HiveField(4)
  String? senderName;

  @HiveField(5)
  String? senderType;

  @HiveField(6)
  String? senderEmail;

  ChatMessage({
    this.donationId,
    this.senderId,
    this.message,
    this.timestamp,
    this.senderName,
    this.senderType,
    this.senderEmail,
  });
}