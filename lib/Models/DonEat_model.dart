import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'DonEat_model.g.dart';

@HiveType(typeId:10)

class Donor extends HiveObject{
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
  required this.name,
  required this.email,
  required this.phone,
  required this.password,
  this.profilePhotoPath,
});
}

@HiveType(typeId: 11)
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
  String? vehicleType;
  
  @HiveField(5)
  int? capacity;
  
  @HiveField(6)
  String? profilePhotoPath;

  Agent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePhotoPath,
    required this.vehicleType,
    required this.capacity
});
}

@HiveType(typeId: 12)
class Donation extends HiveObject {
  @HiveField(0)
  String foodName;

  @HiveField(1)
  String location;

  @HiveField(2)
  String date;

  @HiveField(3)
  String time;

  @HiveField(4)
  String contact;

  @HiveField(5)
  int quantity;

  @HiveField(6)
  List<String>? imagePaths;

  Donation({
    required this.foodName,
    required this.location,
    required this.date,
    required this.time,
    required this.contact,
    required this.quantity,
    this.imagePaths,
  });
}