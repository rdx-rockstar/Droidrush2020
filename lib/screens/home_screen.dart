import 'dart:ui';

import 'package:ShareApp/constants/color_constant.dart';
import 'package:ShareApp/widgets/customAppbar.dart';
import 'package:ShareApp/widgets/showScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;
  int _selectedIndex = 0;
  String userName;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List to save data
  // List<SaveData> check = [
  //   // SaveData(fileName: "This is a Just Dummy message", whichSide: "Send", dateTime: "", otherUserId: "i889H"),
  // ];
  // SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSP();
  }

  // LOADING THE SHARED PREFERENCES
  void loadSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("userName");
  }

  @override
  Widget build(BuildContext context) {
    // appendList("This is a just Dummy message", "Send", "ng67e");
    // String userName = sharedPreferences.getString('userName');
    CustomAppBars appbar = new CustomAppBars(index: this._selectedIndex);
    return Scaffold(
      appBar: appbar.getAppBar(context),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("userName"),
              accountEmail: Text("fetchfrom@firebase.com"),
              currentAccountPicture: new GestureDetector(
                onTap: () => print('To implement This Function'),
                // FUNCTION WHICH CAN BE
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text("MiA3"),
                ),
              ),
            ),
            ListTile(
              title: Text("Local Sharing"),
              leading: Icon(Icons.settings),
              onTap: () => print('To Implement'),
            ),
            ListTile(
              title: Text("Cloud Storage"),
              leading: Icon(Icons.settings),
              onTap: () => print('To Implement'),
            ),
            ListTile(
              title: Text("History"),
              leading: Icon(Icons.settings),
              onTap: () => print('To Implement'),
            ),
            ListTile(
              title: Text("Setting"),
              leading: Icon(Icons.settings),
              onTap: () => print('To Implement'),
            ),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.question_answer_rounded),
            ),
            ListTile(
              title: Text("Close"),
              leading: Icon(Icons.close_rounded),
              onTap: () => Navigator.of(context).pop(),
            ),
            new Divider(),
            ListTile(
              title: Text("Rate This App"),
              trailing: Icon(Icons.star_rate_rounded),
            ),
          ],
        ),
      ),
      backgroundColor: mBackgroundColor,
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: mFillColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, 5))
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              title: Text("CloudStorage"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off_outlined),
              title: Text("History"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text("Accounts"),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: mBlueColor,
          unselectedItemColor: mSubtitleColor,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
      body: ShowScreen(index: _selectedIndex),
    );
  }
}
