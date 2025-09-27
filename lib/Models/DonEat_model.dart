import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'DonEat_model.g.dart';

@HiveType(typeId:0)

class Donor extends HiveObject{
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  int? phone;

  @HiveField(3)
  String? password;

Donor({
  required this.name,
  required this.email,
  required this.phone,
  required this.password
});
}

@HiveType(typeId: 1)
class Agent extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;
  
  @HiveField(2)
  int? phone;
  
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

