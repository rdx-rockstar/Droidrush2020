import 'package:ShareApp/models/user_model.dart';
import 'package:ShareApp/screens/Authentication/authentication.dart';
import 'package:ShareApp/screens/CloudStorage/cloudStorage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user == null){
      return Authentication();
    }
    else{
      return CloudStorage();
    }
  }
}
