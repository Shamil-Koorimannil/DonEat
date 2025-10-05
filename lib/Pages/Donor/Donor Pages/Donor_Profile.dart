import 'dart:io';
import 'package:doneat/Pages/Donor/Donor%20Widgets/header.dart';
import 'package:doneat/Pages/Login-Signup/Agent%20register.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../../../Models/DonEat_model.dart';
import '../../Login-Signup/login.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  late Donor _donor;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _profilePhotoPath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadDonor);
  }



  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePhotoPath = pickedFile.path;
      });
    }
  }

  Future<void> _loadDonor() async {
    var sessionBox = Hive.box('session');
    var donorsBox = Hive.box<Donor>('donors');
    int? index = sessionBox.get('loggedInUserIndex');

    if (index == null || donorsBox.length <= index) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
            (route) => false,
      );
      return;
    }

    _donor = donorsBox.getAt(index)!;

    setState(() {
      _nameController.text = _donor.name ?? '';
      _emailController.text = _donor.email ?? '';
      _phoneController.text = _donor.phone ?? '';
      _passwordController.text = _donor.password ?? ''; // load password correctly
      _profilePhotoPath = _donor.profilePhotoPath;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      var sessionBox = Hive.box('session');
      var donorsBox = Hive.box<Donor>('donors');
      int? index = sessionBox.get('loggedInUserIndex');

      if (index != null) {
        _donor.name = _nameController.text;
        _donor.email = _emailController.text;
        _donor.phone = _phoneController.text;
        _donor.password = _passwordController.text; // save password
        _donor.profilePhotoPath = _profilePhotoPath;

        await donorsBox.putAt(index, _donor);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    }
  }


  void _logout() {
    Hive.box('session').delete('loggedInUserIndex');
    Hive.box('session').delete('userType');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: DonorHead(),
              child: Container(
                height: 200,
                color: const Color(0xFFFF863B),
                alignment: Alignment.center,
                child: const Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Profile picture
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePhotoPath != null
                    ? FileImage(File(_profilePhotoPath!))
                    : null,
                child: _profilePhotoPath == null ? const Icon(
                    Icons.person, size: 50, color: Colors.white) : null,
                backgroundColor: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildStyledTextField(_nameController, "Name"),
                    const SizedBox(height: 20),
                    _buildStyledTextField(_emailController, "Email"),
                    const SizedBox(height: 20),
                    _buildStyledTextField(_phoneController, "Phone"),
                    const SizedBox(height: 20),
                    _buildStyledTextField(
                        _passwordController, "Password", obscureText: true),
                    const SizedBox(height: 30),

                    // Save button aligned right
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
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you want to become an agent? You will be logged out from your donor account."),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF863B),
                                ),
                                child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  // Log donor out
                                  Hive.box('session').delete('loggedInUserIndex');
                                  Hive.box('session').delete('userType');

                                  // Navigate to AgentRegister with donor info
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AgentRegister(
                                        name: _donor.name ?? '',
                                        email: _donor.email ?? '',
                                        phone: _donor.phone ?? '',
                                        password: _donor.password ?? '',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Color(0xFFFF863B)),
                                ),
                                child: const Text("Yes", style: TextStyle(color: Color(0xFFFF863B))),
                              ),
                            ],
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF863B),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Color(0xFFFF863B)),
                        ),
                      ),
                      child: const Text(
                        "Be an Agent",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Logout button
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF863B),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField(TextEditingController? controller, String label,
      {bool readOnly = false, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: obscureText
            ? const Icon(Icons.lock, color: Color(0xFFFF863B))
            : const Icon(Icons.edit, color: Color(0xFFFF863B)),
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
        if (!readOnly && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        if (label == "Phone" && value != null && value.length != 10) {
          return "Phone must be 10 digits";
        }
        return null;
      },
    );
  }
}