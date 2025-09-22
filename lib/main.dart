import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/Splash Screen/splash_screen.dart';

void main() async{
  runApp(DonEat());
}

class DonEat extends StatelessWidget {
  const DonEat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash_Screen(),
    );
  }
}
