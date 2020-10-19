import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/services/storage.dart';
import 'package:flutter/material.dart';

class PublicFiles extends StatefulWidget {
  @override
  _PublicFilesState createState() => _PublicFilesState();
}

class _PublicFilesState extends State<PublicFiles> {

  Storage s = new Storage();
  List<Cloudfile> pf;

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
              child: Text('Get Data'),
              onPressed: () async {
                getFiles();
              },
            )
          ]
        ),
      ),
    );
  }

  void getFiles() async {
    await s.listPublicFiles().then((List<Cloudfile> value){
      pf = value;
      setState(() {});
    });
  }
}
