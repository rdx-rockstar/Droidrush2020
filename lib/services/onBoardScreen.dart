import 'package:ShareApp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ShareApp/FirstTimeUser/main.dart';
import 'package:tuple/tuple.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  setVisiting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('first', true);
  }

  dynamic getVisiting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool visiting = sharedPreferences.getBool('first') ?? false;
    String userName = sharedPreferences.getString('userName');
    if (userName == null) userName = "S";
    return new Tuple2(visiting, userName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getVisiting(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.item1 == true) {
            print('Value which we getting from SP');
            print(snapshot.data.item1);
            print(snapshot.data.item2);
            // print(snapshot.data[1]);
            return HomeScreen(
                userName: snapshot
                    .data.item2); // return HomeScreen(snapshot.data.item2);
          } else {
            setVisiting();
            print('Value which we getting from SP');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
            // return HomeScreen();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
