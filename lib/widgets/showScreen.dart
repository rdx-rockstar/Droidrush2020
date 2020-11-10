import 'package:ShareApp/screens/History/history.dart';
import 'package:ShareApp/screens/Local_Sharing/local_sharing.dart';
import 'package:ShareApp/screens/wrapper.dart';
import 'package:ShareApp/screens/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ShowScreen extends StatefulWidget {
  final int index;
  String userName;
  ShowScreen({this.index, this.userName});
  @override
  _ShowScreenState createState() => _ShowScreenState(this.userName);
}

class _ShowScreenState extends State<ShowScreen> {
  String userName="";
  SharedPreferences sharedPreferences;
  _ShowScreenState(String s){
    this.userName=s;
    print(s+ "11");
  }
  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      setState(() {});
      print(this.userName+" strt");
      return Local_Sharing(widget.userName);
    } else if (widget.index == 1) {
      return Wrapper();
    } else if (widget.index == 2) {
      return History();
    } else {
      return Settings(userName:userName);
    }
  }
  getArchieved() async {
    print("at arch");
    sharedPreferences = await SharedPreferences.getInstance();
    userName =  sharedPreferences.getString('userName');
    print(userName +" f2");
    Future<String> _calculation = Future<String>.delayed(
      Duration(milliseconds: 0),
          () => 'Data Loaded',
    );
    return _calculation;
  }
}
