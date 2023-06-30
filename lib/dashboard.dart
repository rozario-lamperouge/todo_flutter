import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tut1/config.dart';
import 'package:tut1/signin.dart';
import 'package:tut1/todocard.dart';
import 'package:velocity_x/velocity_x.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({super.key, required this.token});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  final todotitle = TextEditingController();
  final tododes = TextEditingController();
  List? todolist;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);
    print(jwtdecodedtoken);
    userId = jwtdecodedtoken['id'];
    gettodolist(userId);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored preferences
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register())
    );
  }


  void CreateTodo() async{
    if(todotitle.text.isNotEmpty && tododes.text.isNotEmpty){

      var todobody = {
        "userId": userId,
        "title": todotitle.text,
        "desc": tododes.text,
      };
      print(todobody);

      var response = await http.post(
          Uri.parse(addtodo),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(todobody)
      );

      var jsonresponse = jsonDecode(response.body);
      print("response =" + jsonresponse.toString());

      if(jsonresponse["status"]){
        print("Todo Added Sucessfully");
        todotitle.clear();
        tododes.clear();
        gettodolist(userId);
      }
      else{
        print("todo creation failed");
      }

    }else{
      print("todo creation failed");
    }
  }

  void gettodolist(userId) async{

      var gettodobody = {
        "userId": userId,
      };
      print(gettodobody);

      var response = await http.post(
          Uri.parse(gettodos),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(gettodobody)
      );

      var jsonresponse = jsonDecode(response.body);
      print(todolist);

      setState(() {
        todolist = jsonresponse['sucess'];
      });

  }

  void deleteItem(id) async {
    var deltodobody = {
      "id": id,
    };
    print(deltodobody);

    var response = await http.post(
        Uri.parse(deletetodo),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(deltodobody)
    );

    var jsonresponse = jsonDecode(response.body);
    print(jsonresponse);
    gettodolist(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userId.text.make(),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: (){
            print("Logout");
            logout();
          }
        )
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("All Tasks", style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                  )),
                ),
              ),
              SizedBox(height: 20,),
              buildExpanded
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              color: Colors.white54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 40,
                            margin: EdgeInsets.only(right: 20,left: 20, top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: todotitle,
                              decoration: InputDecoration(
                                  hintText: "Add a New Task",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            margin: EdgeInsets.only(bottom: 20,right: 20,left: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: tododes,
                              decoration: InputDecoration(
                                  hintText: "Add a Description",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, bottom: 40),
                      height: 60,
                      width: 60,
                      color: Colors.blueAccent,
                      child: ElevatedButton(
                        child: Icon(Icons.add),
                        onPressed: CreateTodo,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            elevation: 5
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded get buildExpanded {
    return Expanded(
      child: todolist == null
          ? Container(height:20, width:200, child: "No Todos Found!".text.center.make())
          : ListView.builder(
          itemCount: todolist!.length,
          itemBuilder: (context, index){
            return TaskCard(
                todo: todolist![index],
                delete: (){
                  print('${todolist![index]['_id']}');
                  var id = '${todolist![index]['_id']}';
                  deleteItem(id);
                },
            );
          }),
    );
  }
}