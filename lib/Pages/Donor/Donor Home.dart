
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login-Signup/login.dart';



class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome> {
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donor'),
        actions: [
          IconButton(onPressed: ()=>logout(context), icon: Icon(Icons.logout)),
        ],
      ),
    );
  }
}

