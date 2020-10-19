import 'package:flutter/material.dart';

class PrivateFiles extends StatefulWidget {
  @override
  _PrivateFilesState createState() => _PrivateFilesState();
}

class _PrivateFilesState extends State<PrivateFiles> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Files',
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Text(
          'Your Files',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
