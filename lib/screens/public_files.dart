import 'package:flutter/material.dart';

class PublicFiles extends StatefulWidget {
  @override
  _PublicFilesState createState() => _PublicFilesState();
}

class _PublicFilesState extends State<PublicFiles> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Public Files',
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Text(
          'Public Files',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
