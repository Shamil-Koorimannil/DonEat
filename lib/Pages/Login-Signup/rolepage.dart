import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'login.dart';
import 'Agent register.dart';
import '../../Models/DonEat_model.dart';

class role extends StatefulWidget {
  final String name;
  final String email;
  final int phone;
  final String password;
  const role({super.key , required this.name, required this.email, required this.phone, required this.password});

  @override
  State<role> createState() => _roleState();
}

class _roleState extends State<role> {
  String? Role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -130,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFFF863B),
                borderRadius: BorderRadius.all(Radius.circular(150)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 160),
                  child: const Text(
                    "Choose Your Role",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Roles("donor", Icons.handshake_rounded, "Donor"),
                  _Roles("agent", Icons.delivery_dining, "Agent"),
                ],
              ),

              const SizedBox(height: 80),

              ElevatedButton(
                  onPressed: Role == null
                      ? null
                      : () async {
                    if (Role == "donor") {
                      var donorBox = Hive.box<Donor>('donors');
                      final donor = Donor(
                        name: widget.name,
                        email: widget.email,
                        phone: widget.phone,
                        password: widget.password,
                      );
                      await donorBox.add(donor);

                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login()));

                    } else if (Role == "agent") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentRegister(
                            name: widget.name,
                            email: widget.email,
                            phone: widget.phone,
                            password: widget.password,
                          ),
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF863B),
                  disabledBackgroundColor: Colors.grey,
                  fixedSize: const Size(180, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Choose",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _Roles(String role, IconData icon, String label) {
    final bool choose = Role == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          Role = role;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: choose ? const Color(0xFFFF863B) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              child: Icon(
                icon,
                size: 50,
                color: choose ? Colors.white : const Color(0xFFFF863B),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: choose ? const Color(0xFFFF863B) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
