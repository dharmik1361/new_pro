import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewScreen extends StatelessWidget {
  final String description;
  final String title;
  const NewScreen({Key? key, required this.description, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBE7C6),
      appBar: AppBar(
        backgroundColor: Color(0xffB44915),
        title: Text(title,style: TextStyle(color: Colors.white),),
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Image.asset("assets/Setting/Arrowback.png")),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(description,style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ], ),
    );
  }
}
