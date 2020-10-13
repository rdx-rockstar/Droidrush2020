import 'package:flutter/material.dart';

class sharing extends StatelessWidget {
  String s = "send";
  String userName = "Random";

  sharing(String s, String userName) {
    this.s = s;
    this.userName = userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: Text("Sharing Screens")),
      ),
      body: Center(
        child: Container(
          child: Text(
              "This is sharing app screens doing the process in the backgroud"),
        ),
      ),
    );
  }
}
