
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

// Future<void> _logout() async {
//   var sessionBox = Hive.box('session');
//   await sessionBox.delete('loggedInUserIndex'); // remove only session
//   if (mounted) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const Login()),
//           (route) => false,
//     );
//   }
// }
