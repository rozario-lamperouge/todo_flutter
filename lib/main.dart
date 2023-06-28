import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tut1/dashboard.dart';
import 'package:tut1/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MyApp(token: pref.getString('token')));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (JwtDecoder.isExpired(token) == true)
          ? const Login()
          : Dashboard(token: token),
    );
  }
}
