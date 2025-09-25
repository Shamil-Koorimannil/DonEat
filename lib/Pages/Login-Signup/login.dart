import 'package:doneat/Pages/Login-Signup/signup.dart';
import 'package:doneat/Pages/Splash%20Screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
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
                  decoration: BoxDecoration(
                    color: Color(0xFFFF863B),
                  ),
                  child: Center(
                      child: Text('Login',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w700),)),
                ),
              ),

            Padding(padding: EdgeInsets.all(50),
            child: Form(
                key: _formKey,
                child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,color: Color(0xFFFF863B),),
                      labelText: 'Email',

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF863B), width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF863B), width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      // Border when there is an error
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),

                    validator: (value){
                      if(value == null || value.isEmpty || !value.contains('@')){
                        return 'Please enter your email';
                      }
                      return null;
                  }
                  ),
                  const SizedBox(height: 30,),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password_rounded,color: Color(0xFFFF863B),),
                    labelText: 'Password',

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

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  }
                ),
                  const SizedBox(height: 30,),

                  // ElevatedButton(onPressed: onPressed, child: child)
                  const SizedBox(height: 250,),
                  Text('Dont have an account?'), TextButton(onPressed: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()))}, child: Text('Signup',style: TextStyle(color: Color(0xFFFF863B)),))
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


class LoginHead extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.60,   // control point
      size.width * 0.5, size.height * 0.65,    // middle curve
    );

    path.quadraticBezierTo(
      size.width * 0.70, size.height * 0.75,   // control point
      size.width, 0,           // end curve
    );

    path.lineTo(size.width, 0); // top-right corner
    path.close();
    return path;
  }



  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
  }
