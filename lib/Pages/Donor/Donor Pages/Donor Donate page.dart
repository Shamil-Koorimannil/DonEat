import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../../../Models/DonEat_model.dart';
import '../Donor Widgets/header.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  final _formKey = GlobalKey<FormState>();

  final foodController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final contactController = TextEditingController();

  double _sliderValue = 50;
  bool _agree = false;
  final ImagePicker _picker = ImagePicker();

  List<File?> _selectedImages = [null, null, null];

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  bool _validateForm() {
    return foodController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        contactController.text.length == 10 &&
        _agree &&
        _selectedImages.any((img) => img != null);
  }

  void _saveDonation() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload at least 1 image")),
      );
      return;
    }

    final box = Hive.box<Donation>('donations');

    final donation = Donation(
      foodName: foodController.text,
      location: locationController.text,
      date: dateController.text,
      time: timeController.text,
      contact: contactController.text,
      quantity: _sliderValue.toInt(),
      imagePaths: _selectedImages
          .where((img) => img != null)
          .map((img) => img!.path)
          .toList(),
    );

    await box.add(donation);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Donation saved ✅")),
    );

    // reset form
    foodController.clear();
    locationController.clear();
    dateController.clear();
    timeController.clear();
    contactController.clear();
    setState(() {
      _sliderValue = 50;
      _agree = false;
      _selectedImages = [null, null, null];
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFFF863B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2),
      ),
    );
  }

  Widget _imageUploadBox(File? imageFile, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 90,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFFF863B)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: imageFile == null
            ? const Icon(Icons.add, color: Color(0xFFFF863B), size: 40)
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(imageFile, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = _validateForm();

    return Scaffold(
      body: Column(
        children: [

          ClipPath(
            clipper: DonorHead(),
            child: Container(
              color: const Color(0xFFFF863B),
              height: 200,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(CupertinoIcons.back, size: 30),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Text(
                      'Donate',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: foodController,
                      decoration: _inputDecoration("Food name"),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: locationController,
                      decoration: _inputDecoration("Pickup location"),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: _inputDecoration("Pickup Date"),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: _inputDecoration("Pickup Time"),
                      onTap: _pickTime,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: contactController,
                      decoration: _inputDecoration("Contact number"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Quantity(People):  ",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFF863B)),
                          ),
                          child: Text("${_sliderValue.toInt()}"),
                        ),
                      ],
                    ),

                    Slider(
                      value: _sliderValue,
                      min: 5,
                      max: 300,
                      divisions: 295,
                      activeColor: const Color(0xFFFF863B),
                      inactiveColor: Colors.orange.shade100,
                      onChanged: (val) {
                        setState(() => _sliderValue = val);
                      },
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) {
                        return _imageUploadBox(
                          _selectedImages[index],
                              () => _pickImage(index),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agree,
                          onChanged: (val) {
                            setState(() => _agree = val ?? false);
                          },
                          activeColor: const Color(0xFFFF863B),
                        ),
                        const Expanded(
                          child: Text(
                            "I hereby consent that the quality of the food is good",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isFormValid ? _saveDonation : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isFormValid ? const Color(0xFFFF863B) : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Donate",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
