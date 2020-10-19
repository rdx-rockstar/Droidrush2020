import 'package:flutter/material.dart';
import 'package:ShareApp/services/storage.dart';

class uploadFilesToCloud extends StatefulWidget {

  var path;
  uploadFilesToCloud({ this.path });

  @override
  _uploadFilesToCloudState createState() => _uploadFilesToCloudState();
}

class _uploadFilesToCloudState extends State<uploadFilesToCloud> {

  Storage st = new Storage();

  @override
  Widget build(BuildContext context) {
    String content="",names="";
    for(int i=0; i< widget.path.length; i++){
      content += widget.path.values.toList()[i];
      names += widget.path.keys.toList()[i];
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Upload Files to Cloud'),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.file_present),
                Text(names),
              ],
            ),
            RaisedButton(
              child: Text('Upload Publicly'),
              onPressed: () async {
                st.uploadFileToPublic('new.jpg', widget.path.values.toList()[0]);
              },
            ),
            RaisedButton(
              child: Text('Uplaod Privately'),
              onPressed: () async {

              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> publicUploadDialog() async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text("QR Code"),
              Spacer(
                flex: 2,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(widget.path.length.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
