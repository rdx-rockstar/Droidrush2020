import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/models/user_model.dart';
import 'package:ShareApp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:ShareApp/constants/color_constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PrivateFiles extends StatefulWidget {
  final User user;
  PrivateFiles({this.user});

  @override
  _PrivateFilesState createState() => _PrivateFilesState();
}

class _PrivateFilesState extends State<PrivateFiles> {
  List<Cloudfile> pf;
  var url;
  bool theFirstOne = true;
  void listFromPF() async {
    // List<Cloudfile> toReturn = [];
    await Storage()
        .listPrivateFiles(widget.user.uid)
        .then((List<Cloudfile> value) {
      pf = value;
      setState(() {});
    });
  }

  String getTheDownloadURI() {
    String File_name;
    final _formKey = GlobalKey<FormState>();
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text("DownloadKeyOfFile"),
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
                      decoration:
                          textInputDecoration.copyWith(hintText: 'File Name'),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return File_name;
  }

  @override
  Widget build(BuildContext context) {
    print('This is the user id that we calling from ${widget.user.uid}');
    Future<List<Cloudfile>> privateRecords =
        Storage().listPrivateFiles(widget.user.uid);
    return MaterialApp(
      title: 'Private Files',
      debugShowCheckedModeBanner: false,
      home: Align(
        alignment: Alignment.topCenter,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: RaisedButton(
                child: Text('DisplayData'),
                onPressed: () async {
                  if (pf != null) {
                    for (int i = 0; i < pf.length; i++) {
                      print(pf[i].File_name);
                    }
                  }
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: RaisedButton(
                child: Text('DownloadURl'),
                onPressed: () async {
                  String s = await getTheDownloadURI();
                  url = await Storage()
                      .downloadPrivateFileWithUrl(s, widget.user.uid);
                  if (url == null) {
                    Fluttertoast.showToast(
                      msg: "Please provide a valid String",
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16,
                    );
                  } else
                    setState(() {});
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: RaisedButton(
                child: Text('FileFromKey'),
                onPressed: () async {
                  url = await Storage().fetchFileFromKey(
                      "rG6nFH0BJuYPddOmG1PEbFlxRwA2:1603139309967");
                  setState(() {
                    print("url: ");
                    print(url);
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: RaisedButton(
                child: Icon(Icons.refresh),
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
            ),
          ]),
          FutureBuilder(
            future: privateRecords,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Row(children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          Cloudfile project = snapshot.data[index];
                          print(project.toString());
                          return ListTile(
                            title: Text(project.File_name),
                            leading: Icon(Icons.image),
                            // subtitle: Text(project.LUri),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ]);
                // return Row(children: <Widget>[
                //   Expanded(
                //     child: SingleChildScrollView(
                //       child: ListView.separated(
                //         // shrinkWrap: true,
                //         itemCount: snapshot.data.length,
                //         separatorBuilder: (context, index) => Divider(),
                //         itemBuilder: (context, index) {
                //           Cloudfile project = snapshot.data[index];
                //           print(
                //               'This is the object that we getting in private ::');
                //           print(project.toString());
                //           return ListTile(
                //             title: Text(project.File_name),
                //             leading: Icon(Icons.image),
                //             subtitle: Text(project.LUri),
                //             onTap: () {
                //               print('file name if ${project.File_name}');
                //             },
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ]);
              } else {
                return Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
