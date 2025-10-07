import 'package:doneat/Pages/Login-Signup/rolepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Models/DonEat_model.dart';
import '../Donor/Donor Widgets/header.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      var donorBox = await Hive.openBox<Donor>('donors');
      var agentBox = await Hive.openBox<Agent>('agents');
      bool emailExists = donorBox.values.any((d) => d.email == _emailController.text) ||
          agentBox.values.any((a) => a.email == _emailController.text);

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already registered!')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Role(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: DonorHead(),
              child: Container(
                height: 250,
                width: double.infinity,
                color: const Color(0xFFFF863B),
                child: const Center(
                  child: Text('Sign Up', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty || !value.contains("@") ? "Enter valid email" : null,

                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10, // Limits input to 10 characters
                      decoration: InputDecoration(
                        labelText: "Phone",
                        counterText: "", // Hides the character counter
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter phone number";
                        } else if (value.length != 10) {
                          return "Phone number must be 10 digits";
                        } else if (!value.contains(RegExp(r'^[0-9]+$'))) {
                          return "Phone number must contain only digits";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Enter password" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Confirm Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Confirm your password" : null,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50),
                            backgroundColor: const Color(0xFFFF863B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Login', style: TextStyle(color: Color(0xFFFF863B))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
