import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../../../Concense/keys_consence.dart';
import '../../../Models/DonEat_model.dart';
import '../../Donor/Donor Pages/Donor Home.dart';
import '../../Login-Signup/login.dart';
import '../Agent Widgets/header.dart';

class AgentProfile extends StatefulWidget {
  const AgentProfile({super.key});

  @override
  State<AgentProfile> createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> {
  late Agent _agent;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? selectedVehicle;
  int capacity = 50;
  final TextEditingController _capacityController = TextEditingController(text: "50");

  String? _profilePhotoPath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadAgent);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePhotoPath = pickedFile.path;
      });
    }
  }

  Future<void> _loadAgent() async {
    var sessionBox = Hive.box(KeysConstant.sessionBox);
    var agentBox = Hive.box<Agent>(KeysConstant.agentsBox);
    int? index = sessionBox.get(KeysConstant.loggedInUserIndex);

    if (index == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
            (route) => false,
      );
      return;
    }

    if (agentBox.length <= index) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
            (route) => false,
      );
      return;
    }

    _agent = agentBox.getAt(index)!;

    setState(() {
      _nameController.text = _agent.name ?? '';
      _emailController.text = _agent.email ?? '';
      _phoneController.text = _agent.phone ?? '';
      _passwordController.text = _agent.password ?? '';
      _profilePhotoPath = _agent.profilePhotoPath;
      selectedVehicle = _agent.vehicleType;
      capacity = _agent.capacity!;
      _capacityController.text = capacity.toString();
      _isLoading = false;
    });
  }

  Future<void> _debugAgents() async {
    var agentBox = Hive.box<Agent>(KeysConstant.agentsBox);
    for (int i = 0; i < agentBox.length; i++) {
      var agent = agentBox.getAt(i);
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      var sessionBox = Hive.box(KeysConstant.sessionBox);
      var agentBox = Hive.box<Agent>(KeysConstant.agentsBox);
      int? index = sessionBox.get(KeysConstant.loggedInUserIndex);

      await _debugAgents();

      if (index != null && index < agentBox.length) {
        _agent.name = _nameController.text;
        _agent.email = _emailController.text;
        _agent.phone = _phoneController.text;
        _agent.password = _passwordController.text;
        _agent.profilePhotoPath = _profilePhotoPath;
        _agent.vehicleType = selectedVehicle ?? "Unknown";
        _agent.capacity = capacity;

        await agentBox.putAt(index, _agent);
        await _agent.save();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving profile")),
        );
      }
    }
  }

  Future<void> _becomeDonor() async {
    var sessionBox = Hive.box(KeysConstant.sessionBox);
    var agentBox = Hive.box<Agent>(KeysConstant.agentsBox);
    var donorBox = Hive.box<Donor>(KeysConstant.donorsBox);
    int? index = sessionBox.get(KeysConstant.loggedInUserIndex);

    if (index != null) {
      Agent currentAgent = agentBox.getAt(index)!;

      Donor newDonor = Donor(
        name: currentAgent.name!,
        email: currentAgent.email!,
        phone: currentAgent.phone!,
        password: currentAgent.password!,
        profilePhotoPath: currentAgent.profilePhotoPath,
      );

      await donorBox.add(newDonor);
      int donorIndex = donorBox.length - 1;
      await agentBox.deleteAt(index);
      await sessionBox.put(KeysConstant.loggedInUserIndex, donorIndex);
      await sessionBox.put(KeysConstant.userType, 'donor');

      bool agentStillExists = false;
      for (int i = 0; i < agentBox.length; i++) {
        var agent = agentBox.getAt(i);
        if (agent?.email == currentAgent.email) {
          agentStillExists = true;
          break;
        }
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DonorHome()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: AgentHead(),
              child: Container(
                color: const Color(0xFFFF863B),
                height: 180,
                width: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePhotoPath != null ? FileImage(File(_profilePhotoPath!)) : null,
                child: _profilePhotoPath == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildStyledTextField(_nameController, "Name"),
                    const SizedBox(height: 15),
                    _buildStyledTextField(_emailController, "Email"),
                    const SizedBox(height: 15),
                    _buildStyledTextField(_phoneController, "Phone"),
                    const SizedBox(height: 15),
                    _buildStyledTextField(_passwordController, "Change Password", obscureText: true),
                    const SizedBox(height: 20),
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
                          value: selectedVehicle,
                          hint: const Text("Vehicle"),
                          items: ["Bicycle","Motorbike / Scooter","Auto Rickshaw","Car","Van"]
                              .map((v) => DropdownMenuItem(
                            value: v,
                            child: Center(
                              child: Text(v, style: const TextStyle(fontSize: 16)),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedVehicle = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Change your limit:"),
                        Container(
                          width: 50,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(capacity.toString()),
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
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF863B),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _becomeDonor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF863B),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Color(0xFFFF863B)),
                        ),
                      ),
                      child: const Text("Be a Donor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Hive.box(KeysConstant.sessionBox).delete(KeysConstant.loggedInUserIndex);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF863B),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Logout", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField(TextEditingController? controller, String label, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: obscureText ? const Icon(Icons.lock, color: Color(0xFFFF863B)) : const Icon(Icons.edit, color: Color(0xFFFF863B)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "$label is required";
        if (label == "Phone" && value.length != 10) return "Phone must be 10 digits";
        return null;
      },
    );
  }
}