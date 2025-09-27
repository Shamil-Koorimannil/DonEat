import 'package:doneat/Pages/Login-Signup/rolepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Models/DonEat_model.dart';
import 'Pages/Splash Screen/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DonorAdapter());
  Hive.registerAdapter(AgentAdapter());

  await Hive.openBox<Donor>('donors');
  await Hive.openBox<Agent>('agents');
  runApp(DonEat());
}

class DonEat extends StatelessWidget {
  const DonEat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF666666)
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Splash_Screen(),
    );
  }
}
