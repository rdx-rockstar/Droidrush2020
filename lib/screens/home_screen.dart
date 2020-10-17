import 'dart:math';
import 'dart:ui';

import 'package:ShareApp/constants/color_constant.dart';
import 'package:ShareApp/widgets/customAppbar.dart';
import 'package:ShareApp/widgets/showScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    CustomAppBars appbar = new CustomAppBars(index: this._selectedIndex);
    return Scaffold(
      appBar: appbar.getAppBar(),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("MiA3"),
              accountEmail: Text("fetchfrom@firebase.com"),
              currentAccountPicture: new GestureDetector(
                onTap: () =>
                    print(
                        'To implement This Function'),
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? new SvgPicture.asset('assets/icons/home_colored.svg')
                    : new SvgPicture.asset('assets/icons/home.svg'),
                label: "Home"),
            BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? new SvgPicture.asset('assets/icons/order_colored.svg')
                    : new SvgPicture.asset('assets/icons/order.svg'),
                label: "Chats"),
            BottomNavigationBarItem(
                icon: _selectedIndex == 2
                    ? new SvgPicture.asset('assets/icons/watch_colored.svg')
                    : new SvgPicture.asset('assets/icons/watch.svg'),
                label: "History"),
            BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? new SvgPicture.asset('assets/icons/account_colored.svg')
                    : new SvgPicture.asset('assets/icons/account.svg'),
                label: "Accounts"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: mBlueColor,
          unselectedItemColor: mSubtitleColor,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
      body: ShowScreen(index: _selectedIndex),
    );
  }
}
