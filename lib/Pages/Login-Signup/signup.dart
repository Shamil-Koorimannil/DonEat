import 'package:doneat/Pages/Login-Signup/rolepage.dart';
import 'package:flutter/material.dart';


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
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context)=>role(
        name: _nameController.text,
        email: _emailController.text,
        phone: int.parse(_phoneController.text),
        password: _passwordController.text
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: SignupHead(),
              child: Container(
                height: 250,
                width: double.infinity,
                color: Color(0xFFFF863B),
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold,color: Colors.white,),
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
                      decoration: InputDecoration(labelText: "Name",
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF863B), width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),

                      validator: (value) => value == null ||
                          value.isEmpty ||
                          !value.contains("@")
                          ? "Enter valid email"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "Phone",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 2),
                          borderRadius: BorderRadius.circular(30.0),
                        ),

                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),

                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter phone number"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter password"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Confirm Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF863B), width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Confirm your password"
                          : null,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 50),
                            backgroundColor: Color(0xFFFF863B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text('Already have an account?'), TextButton(onPressed: ()=>{Navigator.pop(context)}, child: Text('Login',style: TextStyle(color: Color(0xFFFF863B)),))

          ],

        ),
      ),
    );
  }
}


class SignupHead extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.60,
      size.width * 0.5, size.height * 0.65,
    );

    path.quadraticBezierTo(
      size.width * 0.70, size.height * 0.75,
      size.width, 0,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }



  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
