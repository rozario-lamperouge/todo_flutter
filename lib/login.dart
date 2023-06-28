import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isValid = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await prefs.setString('token', token);
  }


  void loginUser() async{
    if(_email.text.isNotEmpty && _password.text.isNotEmpty){

      var logbody = {
        "email": _email.text,
        "password": _password.text
      };
      print(logbody);

      var response = await http.post(
          Uri.parse(login),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(logbody)
      );

      var jsonresponse = jsonDecode(response.body);
      print("response =" + jsonresponse.toString());

      if(jsonresponse["status"]){
        print("user Logged Sucessfully");
        var mytoken = jsonresponse["token"];
        saveToken(mytoken);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(token: mytoken))
        );
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
              "Login",
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
                child: Text("Login"),
                onPressed: loginUser,
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
            "Create A New Account".text.white.makeCentered(),
            const SizedBox(width: 5),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: "Register".text.bold.white.makeCentered()),
          ],
        ),
      ),
    );
  }
}
