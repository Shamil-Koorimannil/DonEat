import 'package:doneat/Concense/keys_consence.dart';
import 'package:doneat/Models/DonEat_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Donor/Donor Widgets/header.dart';
import 'signup.dart';
import '../Agent/Agent Home.dart';
import '../Donor/Donor Pages/Donor Home.dart';
import 'package:doneat/Concense/keys_consence.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final agentBox = Hive.box<Agent>('agents');
    final donorBox = Hive.box<Donor>('donors');
    final sessionBox = Hive.box('session');

    Agent? agent;
    Donor? donor;
    int agentIndex = -1;
    int donorIndex = -1;

    // Check agents first
    for (int i = 0; i < agentBox.length; i++) {
      var a = agentBox.getAt(i);
      if (a?.email == email && a?.password == password) {
        agent = a;
        agentIndex = i;
        break;
      }
    }

    // If no agent found, check donors
    if (agent == null) {
      for (int i = 0; i < donorBox.length; i++) {
        var d = donorBox.getAt(i);
        if (d?.email == email && d?.password == password) {
          donor = d;
          donorIndex = i;
          break;
        }
      }
    }

    if (agent != null) {
      await sessionBox.put('loggedInUserIndex', agentIndex);
      await sessionBox.put('userType', 'agent');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AgentHome()),
            (route) => false,
      );
    } else if (donor != null) {
      await sessionBox.put('loggedInUserIndex', donorIndex);
      await sessionBox.put('userType', 'donor');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DonorHome()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipPath(
              key: UniqueKey(),
              clipper: DonorHead(),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF863B),
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email,
                            color: Color(0xFFFF863B)),
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock,
                            color: Color(0xFFFF863B)),
                        labelText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFFF863B), width: 2),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF863B),
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text("Don’t have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Color(0xFFFF863B)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}