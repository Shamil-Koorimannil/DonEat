import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doneat/Pages/Login-Signup/login.dart';

import '../Agent/Agent Home.dart';
import '../Donor/Donor Home.dart';


class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    _alreadylogged();
  }

  Future<void> _alreadylogged() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

    if (!mounted) return;

    if (isLoggedIn && role == "donor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DonorHome()),
      );
    } else if (isLoggedIn && role == "agent") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AgentHome()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF863B),
      body: Center(
        child: Image.asset('assets/icons/DonEat_logo.jpg'),
      ),
    );
  }
}
