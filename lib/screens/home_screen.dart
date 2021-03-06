import 'dart:ui';

import 'package:ShareApp/constants/color_constant.dart';
import 'package:ShareApp/screens/History/received.dart';
import 'package:ShareApp/screens/Local_Sharing/apk_list.dart';
import 'package:ShareApp/screens/Local_Sharing/ftpServer.dart';
import 'package:ShareApp/widgets/customAppbar.dart';
import 'package:ShareApp/widgets/showScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about.dart';


class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({Key key, this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName="";
  SharedPreferences sharedPreferences;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if(index<=3){
    setState(() {
      _selectedIndex = index;
    });}
    else{

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSP();
    print("drawer init");
  }

  void loadSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loaduserName();
  }

  loaduserName() async {
    userName = sharedPreferences.getString('userName');
    setState(() {});
    print(userName +" f1");
  }

  @override
  Widget build(BuildContext context) {
    // appendList("This is a just Dummy message", "Send", "ng67e");
    CustomAppBars appbar = new CustomAppBars(index: this._selectedIndex);
    print("at build home");
    return Scaffold(
      appBar: appbar.getAppBar(context),
      drawer: new Drawer(
        child: new ListView(

          children: <Widget>[
            GestureDetector(
              onTap: () {
                _selectedIndex = 3;
                Navigator.pop(context);
                setState(() {});
              },
              child: Container(
                child: FutureBuilder(
                    future: getArchieved(),
                    builder: (context, data) {
                      if (data.hasData) {
                        return new UserAccountsDrawerHeader(
                          accountName: Text(userName+""),
                          accountEmail: Text(""),
                          currentAccountPicture: new CircleAvatar(
                            backgroundImage: AssetImage('assets/images/fmainJ.jpg'),
                          ),
                        );
                      }
                      else{
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                )
              ),
            ),
//    Container(
//    child: FutureBuilder(
//    future: getArchieved(),
//    builder: (context, data) {
//    if (data.hasData) {
//      return new UserAccountsDrawerHeader(
//        accountName: Text(userName+""),
//        accountEmail: Text(""),
//        currentAccountPicture: new CircleAvatar(
//          backgroundImage: AssetImage('assets/images/fmainJ.jpg'),
//        ),
//      );
//    }
//    else{
//      return Center(child: CircularProgressIndicator());
//    }
//    })),

            // ListTile(
            //   title: Text("Web Sharing"),
            //   leading: Icon(Icons.laptop_chromebook),
            //   onTap: () {
            //    // Here we can add ftp transfer
            //   },
            // ),
//            ListTile(
//              title: Text("Local Sharing"),
//              leading: Icon(Icons.offline_share),
//              onTap: () {
//                _selectedIndex = 0;
//                Navigator.pop(context);
//                setState(() {});
//              },
//            ),
            ListTile(
              title: Text("Pc Sharing"),
              leading: Icon(Icons.computer_outlined),
              onTap: (){ Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ftpServer()));
              },
            ),
//            ListTile(
//              title: Text("Cloud Sharing and Storage"),
//              leading: Icon(Icons.web_sharp),
//              onTap: () {
//                _selectedIndex = 1;
//                Navigator.pop(context);
//                setState(() {});
//              },
//            ),
//            ListTile(
//              title: Text("History"),
//              leading: Icon(Icons.history),
//              onTap: () {
//                _selectedIndex = 2;
//                Navigator.pop(context);
//                setState(() {});
//              },
//            ),
            ListTile(
              title: Text("Recived files"),
              leading: Icon(Icons.file_download),
              onTap: (){ Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Downloads()));
              },
            ),
//            ListTile(
//              title: Text("Accounts"),
//              leading: Icon(Icons.settings),
//              onTap: () {
//                _selectedIndex = 3;
//                Navigator.pop(context);
//                setState(() {});
//              },
//            ),
            // ListTile(
            //   title: Text("About"),
            //   leading: Icon(Icons.question_answer_rounded),
            // ),

            ListTile(
              title: Text("Apk Extractor"),
              leading: Icon(Icons.android_outlined),
              onTap: (){ Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApkExtractor(0)));
              },
            ),
            ListTile(
              title: Text("About us"),
              leading: Icon(Icons.info_outline),
              onTap: (){ Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => About()));
              },
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
      body:ShowScreen(index: _selectedIndex, userName: userName)
    );
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
