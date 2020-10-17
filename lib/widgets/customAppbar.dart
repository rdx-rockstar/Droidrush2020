import 'package:flutter/material.dart';
import 'package:ShareApp/constants/color_constant.dart';

class CustomAppBars {
  int _index;
  CustomAppBars({ int index }){
    this._index = index;
  }

  AppBar getAppBar(){
    if(this._index == 0){
      return AppBar(
        title: Text('Local Sharing'),
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Colors.blue),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
        ],
      );
    }
    else if(this._index == 2){
      return AppBar(
        backgroundColor: mBackgroundColor,
        elevation: 0,
        title: Text('History'),
        iconTheme: new IconThemeData(color: Colors.blue),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
        ],
      );
    }
    else if(this._index == 3){
      return AppBar(
        backgroundColor: mBackgroundColor,
        elevation: 0,
        title: Text('Settings'),
        iconTheme: new IconThemeData(color: Colors.blue),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
        ],
      );
    }
  }
}


