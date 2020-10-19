import 'package:ShareApp/constants/color_constant.dart';
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
                await publicUploadDialog();
                Navigator.of(context).pop();
                // st.uploadFileToPublic('new.jpg', widget.path.values.toList()[0], tags);
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
    String File_name;
    List<String> tags;
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text("Public Uploads"),
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
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'File Name'),
                      validator: (val) =>
                      val.isEmpty ? 'Enter File Name' : null,
                      onChanged: (val) {
                        // get File name
                        setState(() => File_name = val);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Tags'),
                      validator: (val) =>
                      val.isEmpty ? 'Enter Tags' : null,
                      onChanged: (val) {
                        // get Tags
                        setState(() => tags = val.split(" "));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      child: Text('Upload'),
                      onPressed: () async {
                        await st.uploadFileToPublic(File_name, widget.path.values.toList()[0], tags);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
