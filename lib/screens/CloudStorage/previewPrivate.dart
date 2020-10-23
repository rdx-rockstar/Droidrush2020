import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ShareApp/models/Cloudfile.dart';
import 'package:ShareApp/services/storage.dart';

class pageToViewImage extends StatefulWidget {
  final FirebaseUser user;
  final Cloudfile cloudfile;
  const pageToViewImage({Key key, this.cloudfile, this.user}) : super(key: key);

  @override
  _pageToViewImageState createState() => _pageToViewImageState();
}

class _pageToViewImageState extends State<pageToViewImage> {
  @override
  Widget build(BuildContext context) {
    var url = Storage()
        .downloadPrivateFileWithUrl(widget.cloudfile.LUri, widget.user.uid);
    return FutureBuilder<dynamic>(
      future: url,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: Image.network(snapshot.data),
          );
        } else {
          return Center(
              child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
