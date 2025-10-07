import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../Concense/keys_consence.dart';
import 'login.dart';
import 'Agent register.dart';
import '../../Models/DonEat_model.dart';

class Role extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  const Role({super.key , required this.name, required this.email, required this.phone, required this.password});

  @override
  State<Role> createState() => _RoleState();
}

class _RoleState extends State<Role> {
  String? role;

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
                  child: const Text("Choose Your Role", style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRole(KeysConstant.donorUserType, Icons.handshake_rounded, "Donor"),
                  _buildRole(KeysConstant.agentUserType, Icons.delivery_dining, "Agent"),
                ],
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: role == null
                    ? null
                    : () async {
                  if (role == KeysConstant.donorUserType) {
                    var donorBox = Hive.box<Donor>(KeysConstant.donorsBox);
                    final donor = Donor(
                      name: widget.name,
                      email: widget.email,
                      phone: widget.phone,
                      password: widget.password,
                    );
                    await donorBox.add(donor);
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Login()));
                  } else if (role == KeysConstant.agentUserType) {
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
                child: const Text("Choose", style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRole(String roleType, IconData icon, String label) {
    final bool isSelected = role == roleType;
    return GestureDetector(
      onTap: () {
        setState(() {
          role = roleType;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFFFF863B) : Colors.white,
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
                color: isSelected ? Colors.white : const Color(0xFFFF863B),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFFFF863B) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}