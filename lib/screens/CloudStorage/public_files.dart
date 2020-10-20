import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/services/storage.dart';
import 'package:flutter/material.dart';
// import 'package:ShareApp/models/PublicFile.dart';
import 'package:ShareApp/screens/Authentication/Loading.dart';
import 'package:ShareApp/models/Cloudfile.dart';

class PublicFiles extends StatefulWidget {
  @override
  _PublicFilesState createState() => _PublicFilesState();
}

class _PublicFilesState extends State<PublicFiles> {
  Storage s = new Storage();
  List<Cloudfile> pf;
  Future<List<Cloudfile>> record = Storage().listPublicFiles();
  // List<Publicfile> listPublicFiles = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Public Files',
      debugShowCheckedModeBanner: false,
      home: buildListView(),
    );
  }

  Center buildListView() {
    return Center(
      child: Column(children: <Widget>[
        Center(
          child: Row(
            children: <Widget>[
              RaisedButton(
                child: Text('Get Data'),
                onPressed: () async {
                  s.searchPublicFilesWithTags('kgf');
                },
              ),
              RaisedButton(
                child: Text('Refersh the list'),
                onPressed: () {
                  var latestList = Storage().listPublicFiles();
                  setState(() {
                    record = latestList;
                  });
                },
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: record,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Row(children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2 + 100,
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
                          subtitle: Text(project.LUri),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Text('Some error is occured..hit refersh again');
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
        // FutureBuilder(
        //   future: Storage().listPublicFiles(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       return Loading();
        //     } else if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Loading();
        //     } else if (snapshot.connectionState == ConnectionState.none) {
        //       return Loading();
        //     } else if (snapshot.connectionState == ConnectionState.done) {
        //       print('Hi There the connection is done');
        //       print(snapshot.data);
        //       return Container(
        //           height: 500,
        //           child: ListView.builder(
        //             itemCount: snapshot.data.length,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                 title: snapshot.data[index].file_name,
        //               );
        //             },
        //           ));
        //       // String s = '';
        //       // for (int i = 0; i < snapshot.data.length; i++) {
        //       //   s += snapshot.data[i].name();
        //       // }
        //       // return Text(s);
        //     }
        //   },
        // ),
      ]),
    );
  }

  void getFiles() async {
    await s.listPublicFiles().then((List<Cloudfile> value) {
      pf = value;
      setState(() {});
    });
  }
}
