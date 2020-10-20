import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/models/user_model.dart';
import 'package:ShareApp/services/storage.dart';
import 'package:flutter/material.dart';

class PrivateFiles extends StatefulWidget {
  final User user;
  PrivateFiles({this.user});

  @override
  _PrivateFilesState createState() => _PrivateFilesState();
}

class _PrivateFilesState extends State<PrivateFiles> {
  List<Cloudfile> pf;
  var url;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Files',
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Get Data'),
              onPressed: () async {
                // Storage().uploadFileToPrivate()
                await Storage()
                    .listPrivateFiles(widget.user.uid)
                    .then((List<Cloudfile> value) {
                  pf = value;
                  setState(() {});
                });
              },
            ),
            RaisedButton(
              child: Text('Display Data'),
              onPressed: () async {
                if (pf != null) {
                  for (int i = 0; i < pf.length; i++) {
                    print(pf[i].File_name);
                  }
                }
              },
            ),
            RaisedButton(
              child: Text('Download URl'),
              onPressed: () async {
                url = await Storage().downloadPrivateFileWithUrl(
                    "good1603139309967", widget.user.uid);
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text('Get file from key'),
              onPressed: () async {
                url = await Storage().fetchFileFromKey(
                    "rG6nFH0BJuYPddOmG1PEbFlxRwA2:1603139309967");
                setState(() {
                  print("url: ");
                  print(url);
                });
              },
            ),
            url == null ? Text("noimage") : Image.network(url),
          ],
        ),
      ),
    );
  }
}
