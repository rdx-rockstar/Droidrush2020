import 'dart:ui';

import 'package:ShareApp/constants/color_constant.dart';
import 'package:ShareApp/widgets/customAppbar.dart';
import 'package:ShareApp/widgets/showScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({Key key, this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName;
  SharedPreferences sharedPreferences;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSP();
  }

  void loadSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loaduserName();
  }

  loaduserName() async {
    userName = await sharedPreferences.getString('userName');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // appendList("This is a just Dummy message", "Send", "ng67e");
    CustomAppBars appbar = new CustomAppBars(index: this._selectedIndex);
    return Scaffold(
      appBar: appbar.getAppBar(context),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(""),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage('assets/images/fmainJ.jpg'),
              ),
            ),
            // ListTile(
            //   title: Text("Web Sharing"),
            //   leading: Icon(Icons.laptop_chromebook),
            //   onTap: () {
            //    // Here we can add ftp transfer
            //   },
            // ),
            ListTile(
              title: Text("Local Sharing"),
              leading: Icon(Icons.offline_share),
              onTap: () {
                _selectedIndex = 0;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text("Cloud Sharing and Storage"),
              leading: Icon(Icons.web_sharp),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text("History"),
              leading: Icon(Icons.history),
              onTap: () {
                _selectedIndex = 2;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text("Accounts"),
              leading: Icon(Icons.settings),
              onTap: () {
                _selectedIndex = 3;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            // ListTile(
            //   title: Text("About"),
            //   leading: Icon(Icons.question_answer_rounded),
            // ),
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
      body: _selectedIndex == 3
          ? ShowScreen(index: _selectedIndex, userName: widget.userName)
          : ShowScreen(index: _selectedIndex),
    );
  }
}
