import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({super.key, required this.token});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);
    email = jwtdecodedtoken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: email.text.bold.headline5(context).make(),
      ),
    );
  }
}
