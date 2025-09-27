import 'package:doneat/Models/DonEat_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import '../Agent/Agent Home.dart';
import '../Donor/Donor Home.dart';

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

    final email= _emailController.text.trim();
    final password= _passwordController.text.trim();

    final donorBox= await Hive.openBox<Donor>('donors');
    final agentBox= await Hive.openBox<Agent>('agents');

    Donor? donor;
    Agent? agent;

    for (var d in donorBox.values) {
      if (d.email == email && d.password == password) {
        donor = d;
        break;
      }
    }

    if (donor == null) {
      for (var a in agentBox.values) {
        if (a.email == email && a.password == password) {
          agent = a;
          break;
        }
      }
    }

    if (donor != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'donor');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DonorHome()),(route) => false,);
    } else if (agent != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'agent');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AgentHome()),(route) => false,);
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
              clipper: LoginHead(),
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

class LoginHead extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.60,
        size.width * 0.5, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.75, size.width, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
