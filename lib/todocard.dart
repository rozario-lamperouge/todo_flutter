import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final todo;
  final delete;
  const TaskCard({Key? key, this.todo, this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: (){
          print("t.title");
        },
        tileColor: Colors.white,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black)),
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
        leading: Icon(Icons.check_box_outline_blank, color: Colors.blueAccent, size: 25,),
        title: Text(todo['title'], style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: null
        ),),
        subtitle: Text(todo['desc']),
        trailing: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(5)
          ),
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: delete,
            iconSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}