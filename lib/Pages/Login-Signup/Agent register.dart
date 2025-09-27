import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/DonEat_model.dart';
import 'login.dart';



class AgentRegister extends StatefulWidget {
  final String name;
  final String email;
  final int phone;
  final String password;

  const AgentRegister({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  State<AgentRegister> createState() => _AgentRegisterState();
}

class _AgentRegisterState extends State<AgentRegister> {
  String? selectedVehicle;
  int capacity = 50;
  final TextEditingController _capacityController =
  TextEditingController(text: "50");

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  Future<void> _saveAgent() async {
    final box = await Hive.openBox<Agent>('agents');
    final agent = Agent(
      name: widget.name,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      vehicleType: selectedVehicle ?? "Unknown",
      capacity: capacity,
      profilePhotoPath: _imageFile?.path ?? "",
    );
    await box.add(agent);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: SignupHead(),
            child: Container(
              height: 250,
              width: double.infinity,
              color: Color(0xFFFF863B),
              child: Center(
                child: Column(
                  children:[
                    SizedBox(height: 30,),
                    Row(
                    children:[
                IconButton(onPressed:()=> Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back,size: 40,),color: Colors.white,),
                ],),
                    Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold,color: Colors.white,),
                    ),
                  ]
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFFF863B),
                      backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? const Icon(Icons.person, color: Colors.white, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFFF863B)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        value: selectedVehicle,
                        hint: const Text("Select Vehicle"),
                        items: [
                          "Bicycle",
                          "Motorbike / Scooter",
                          "Auto Rickshaw",
                          "Car",
                          "Van"
                        ]
                            .map((v) => DropdownMenuItem(
                          value: v,
                          child: Center(
                            child: Text(
                              v,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedVehicle = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "Choose your limit:",
                    style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: _capacityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onChanged: (value) {
                            final numValue = int.tryParse(value) ?? capacity;
                            setState(() {
                              capacity = numValue.clamp(5, 300);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: capacity.toDouble(),
                    min: 5,
                    max: 300,
                    divisions: 59,
                    activeColor: const Color(0xFFFF863B),
                    label: capacity.toString(),
                    onChanged: (value) {
                      setState(() {
                        capacity = value.toInt();
                        _capacityController.text = capacity.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: selectedVehicle == null ? null : _saveAgent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF863B),
                      disabledBackgroundColor: Colors.grey,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Go to Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}


class SignupHead extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.60,
      size.width * 0.5, size.height * 0.65,
    );

    path.quadraticBezierTo(
      size.width * 0.70, size.height * 0.75,
      size.width, 0,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }



  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

