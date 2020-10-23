import 'package:flutter/material.dart';
import 'package:ShareApp/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBars {
  int _index;
  CustomAppBars({int index}) {
    this._index = index;
  }

  toReloadSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
  }

  toClearSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('check');
  }

  AppBar getAppBar() {
    if (this._index == 0) {
      return AppBar(
        // backgroundColor: Colors.white,
        title: Text('Local Sharing'),
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications_active_outlined),
              onPressed: () => print('To imple')),
        ],
      );
    } else if (this._index == 2) {
      return AppBar(
        backgroundColor: mBlueColor,
        elevation: 0,
        title: Text('History'),
        iconTheme: new IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: () {
                toReloadSP();
              }),
        ],
      );
    } else if (this._index == 3) {
      return AppBar(
        backgroundColor: mBackgroundColor,
        elevation: 0,
        title: Text('Settings'),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
        ],
      );
    }
  }
}
