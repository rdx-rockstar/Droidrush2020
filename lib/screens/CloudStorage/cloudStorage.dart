import 'package:ShareApp/screens/CloudStorage/private_files.dart';
import 'package:ShareApp/screens/CloudStorage/public_files.dart';
import 'package:ShareApp/services/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'uploadFilesToCloud.dart';

class CloudStorage extends StatefulWidget {
  @override
  _CloudStorageState createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  final AuthService _auth = AuthService();
  PopupMenuItemSelected onSelected;
  @override
  Widget build(BuildContext context) {
    return (DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Cloud Storage",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.blue,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: "Public Files",
              ),
              Tab(
                text: "Your Files",
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "1",
                  child: Text('Create New Folder'),
                ),
                PopupMenuItem<String>(
                  value: "2",
                  child: Text('Sort By'),
                ),
                PopupMenuItem<String>(
                  value: "3",
                  child: Text('Logout'),
                ),
              ],
              onSelected: (value) {
                if (value == '3') {
                  _auth.signOut();
                }
              },
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            PublicFiles(),
            PrivateFiles(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload_sharp),
          onPressed: () async {
            // upload file
            var _path = await FilePicker.getMultiFilePath();
            if(_path != null ){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => uploadFilesToCloud( path: _path )));
            }
          },
          backgroundColor: Colors.blue,
        ),
      ),
    ));
  }
}
