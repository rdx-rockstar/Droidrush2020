import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  String directory;
  List file = new List();
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    directory = Directory("/storage/emulated/0/DiGiShare/Received").path;
    setState(() {
      file = io.Directory("$directory/").listSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Received Files"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: file.length,
          itemBuilder: (context, i) {

            ListTile tile = ListTile(
                title: Text(file[i].toString().split('/').last.substring(0,file[i].toString().split('/').last.length-1)),
                onTap: () async {
                await OpenFile.open("/storage/emulated/0/DiGiShare/Received/"+file[i].toString().split('/').last.substring(0,file[i].toString().split('/').last.length-1));
                });
            return tile;
          }));

//      GridView.builder(
//          padding: EdgeInsets.all(10),
//          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//              crossAxisCount: 2,
//              mainAxisSpacing: 10,
//              crossAxisSpacing: 10,
//              childAspectRatio: 0.9),
//          itemCount: file.length,
//          itemBuilder: (context, i) {
//            print(file[i]);
//            return GestureDetector(
//              onTap: () async {
//                print("/storage/emulated/0/DiGiShare/Received"+file[i].toString().split('/').last.substring(0,file[i].toString().split('/').last.length-1));
//               // await OpenFile.open(li[index].path+'setup.apk').then((OpenResult value) {});
//                await OpenFile.open("/storage/emulated/0/DiGiShare/Received/"+file[i].toString().split('/').last.substring(0,file[i].toString().split('/').last.length-1));
//
//              },
//              child: Container(
//                padding: EdgeInsets.all(10),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(4),
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                          color: Colors.grey, blurRadius: 2, spreadRadius: 2),
//                    ]),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    Icon(
//                      Icons.insert_drive_file,
//                      size: 50,
//                      color: Colors.blue,
//                    ),
//                    SizedBox(height: 10),
//                    Text(file[i].toString().split('/').last.substring(0,file[i].toString().split('/').last.length-1))
//                  ],
//                ),
//              ),
//            );
//          }),
//          );
  }
}