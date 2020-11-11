import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About us"),
        ),
        body: Container(
        padding: new EdgeInsets.all(50.0),
          child: new ListView(
          children: <Widget>[
    Text(
          'DiGi Share',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50,),
        ),
            Text(
              '\nA digital sharing app with features:-\n-- P2P sharing of files\n-- Share through cloud storage\n-- Share files with windows/mac\n-- Extract apks\n\n ',
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              style: TextStyle(fontSize: 18,),
            ),
            Text(
              'Developed By :',
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              style: TextStyle(fontWeight:FontWeight.bold,fontSize: 25,),
            ),
            Text(
              '-- Karimulla Mohd\n-- Amit Gupta\n-- Mohd Sahil',
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              style: TextStyle(fontSize: 20,),
            )


          ])));

  }
}