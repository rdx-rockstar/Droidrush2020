import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/services/storage.dart';
import 'package:flutter/material.dart';
// import 'package:ShareApp/constants/data_search.dart';

class PublicFiles extends StatefulWidget {
  @override
  _PublicFilesState createState() => _PublicFilesState();
}

class _PublicFilesState extends State<PublicFiles> {
  //List<Cloudfile> pf = new List();
  Future<List<Cloudfile>> record;

  @override
  void initState() {
    super.initState();
    // this should not be done in build method.
    record = Storage().listPublicFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: 'Public Files',
      // debugShowCheckedModeBanner: false,
      body: buildListView(),
    );
  }

  Widget buildListView() {
    return SingleChildScrollView(
      child: FutureBuilder<List<Cloudfile>>(
        future: record,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Row(children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  // height: MediaQuery.of(context).size.height / 2 + 100,
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
    );
  }
}
