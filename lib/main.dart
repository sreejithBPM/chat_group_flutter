import 'package:chat_grouping/group.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Group {
  String name;
  String description;
  List<User> members;

  Group(this.name, this.description, this.members);
}

class User {
  String name;

  User(this.name);
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }

  
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton( onPressed: () {
            // Navigate to the new section when the button is pressed
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
      
         child: Text("group")),
      ),
    );
  }
}