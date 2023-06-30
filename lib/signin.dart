import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tut1/config.dart';
import 'package:velocity_x/velocity_x.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isValid = true;

  void registerUser() async{
    if(_email.text.isNotEmpty && _password.text.isNotEmpty){

      var regbody = {
        "email": _email.text,
        "password": _password.text
      };

      var response = await http.post(
          Uri.parse(register),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(regbody)
      );

      var jsonresponse = jsonDecode(response.body);
      print("response =" + jsonresponse.toString());

      if(jsonresponse["email"] == _email.text){
        print("user Created Sucessfully");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
      else{
        print("user creation failed");
      }

    }else{
      setState(() {
        isValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("To Do List"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Register",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: AutofillHints.birthday,
                    color: Colors.blueAccent),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: "Email",
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: isValid ? null : "Invalid Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                padding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextField(
                  controller: _password,
                  decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: isValid ? null : "Invalid Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),

                ),
              ),
              Container(
                margin: const EdgeInsets.all(40),
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  child: const Text("Register"),
                  onPressed: registerUser,
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar:
        Container(
          color: Colors.blueAccent,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Already have an account?".text.white.makeCentered(),
              const SizedBox(width: 5),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      )
                    );
                  },
                  child: "Login".text.bold.white.makeCentered()),
            ],
          ),
        ),
    );
  }
}
