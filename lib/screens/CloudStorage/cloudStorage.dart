import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/screens/CloudStorage/private_files.dart';
import 'package:ShareApp/screens/CloudStorage/public_files.dart';
import 'package:ShareApp/services/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'uploadFilesToCloud.dart';
import 'package:ShareApp/services/storage.dart';
import 'package:ShareApp/constants/color_constant.dart';

List<Cloudfile> recordsPublic;
List<Cloudfile> recordsPrivate;

class Screens {
  MaterialApp screen;
  String title;
  Screens({this.screen, this.title});
}

class CloudStorage extends StatefulWidget {
  final FirebaseUser user;
  CloudStorage({this.user});

  @override
  _CloudStorageState createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  final AuthService _auth = AuthService();
  PopupMenuItemSelected onSelected;
  // TabController _tabController;
  int current_index = 0;

  String getFileKey() {
    String File_name;
    final _formKey = GlobalKey<FormState>();
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text("Enter File Key"),
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
                        File_name = val;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      child: Text('Get'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        return File_name;
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
    return File_name;
  }

  void initialize() async {
    await Storage()
        .listPrivateFiles(widget.user.uid)
        .then((List<Cloudfile> value) {
      recordsPrivate = value;
    });
    await Storage().listPublicFiles().then((List<Cloudfile> value) {
      recordsPublic = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // recordsPrivate = Storage().listPrivateFiles();
    initialize();
    // print('This is in the cloud storage file');
    // print(recordsPrivate.length);
    // print(recordsPublic.length);
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
            onTap: (index) {
              current_index = index;
              setState(() {});
            },
            // isScrollable: true,
            indicatorColor: Colors.white,
            // tabs: [],
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
              onPressed: () {
                print(current_index);
                if (current_index == 0)
                  showSearch(context: context, delegate: DataSearchPub());
                else
                  showSearch(context: context, delegate: DataSearchPri());
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
            current_index != 0
                ? IconButton(
                    icon: Icon(Icons.file_copy),
                    onPressed: () async {
                      String fileKey = await getFileKey();
                      print(fileKey);
                    },
                  )
                : SizedBox(width: 1),
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
            PrivateFiles(user: widget.user),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload_sharp),
          onPressed: () async {
            // upload file
            var _path = await FilePicker.getMultiFilePath();
            if (_path != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => uploadFilesToCloud(
                          path: _path, uid: widget.user.uid)));
            }
          },
          backgroundColor: Colors.blue,
        ),
      ),
    ));
  }
}
// This is the class which is used to implement search operation using
// inbuilt SearchDelegate in flutter

class DataSearchPub extends SearchDelegate<String> {
  List<Cloudfile> listPublic = recordsPublic;
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // throw UnimplementedError();
    // final suggestionList = query.isEmpty?:;

    // print('The lena;lfjasla;lkfasfd;lkjasf;lkj');
    // print(suggestionList.length);
    List<Cloudfile> s = query.isEmpty
        ? listPublic
        : listPublic
            .where((element) => element.File_name.contains(query))
            .toList();
    return ListView.builder(
      itemCount: s.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // showResults(context, s[index]);
          },
          title: Text(s[index].File_name),
          leading: Icon(Icons.image),
        );
      },
    );
  }
}

class DataSearchPri extends SearchDelegate<String> {
  List<Cloudfile> listPublic = recordsPrivate;
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // throw UnimplementedError();
    // final suggestionList = query.isEmpty?:;

    // print('The lena;lfjasla;lkfasfd;lkjasf;lkj');
    // print(suggestionList.length);
    List<Cloudfile> s = query.isEmpty
        ? listPublic
        : listPublic
            .where((element) => element.File_name.contains(query))
            .toList();
    return ListView.builder(
      itemCount: s.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // showResults(context, s[index]);
          },
          title: Text(s[index].File_name),
          leading: Icon(Icons.image),
        );
      },
    );
  }
}
