import 'dart:io';
import 'package:ShareApp/services/storage.dart';
import 'package:flutter/material.dart';

class PublicFiles extends StatefulWidget {
  @override
  _PublicFilesState createState() => _PublicFilesState();
}

class _PublicFilesState extends State<PublicFiles> {

  List File_Names;
  String content = '';

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Public Files',
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Public Files',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            RaisedButton(
              child: Text('Retrieve data'),
              onPressed: () async {
                File_Names = await Storage().listPublicFiles();
                for(int i=0; i<File_Names.length ; i++){
                  content += File_Names[i].toString();
                  content += '\n';
                }
                print(content);
                setState(() {});

              },
            ),
            File_Names == null  ?  Text('No files') : Text(content,style: TextStyle(color: Colors.amber, fontSize: 20.0),),
          ]
        ),
      ),
    );
  }
}
