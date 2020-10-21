import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:ShareApp/screens/Local_Sharing/ftpServer.dart';
import 'package:ShareApp/constants/color_constant.dart';

class CustomAppBars {
  int _index;
  CustomAppBars({int index}) {
    this._index = index;
  }

  AppBar getAppBar(BuildContext context) {
    if (this._index == 0) {
      return AppBar(
        // backgroundColor: Colors.white,
        title: Text('Local Sharing'),
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.computer_outlined),
              onPressed:  () async {
                if (await Nearby().checkLocationPermission()) {
                  if (await Nearby().checkExternalStoragePermission()) {
                    if (await Nearby().checkLocationEnabled()) {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => sharing("recieve",userName)));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ftpServer()));
                    } else {
                      if (await Nearby().enableLocationServices()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ftpServer()));
                      }
                    }
                  } else {
                    Nearby().askExternalStoragePermission();
                    if (await Nearby().checkLocationEnabled()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ftpServer()));
                    } else {
                      if (await Nearby().enableLocationServices()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ftpServer()));
                      }
                    }
                  }
                } else {
                  if (await Nearby().askLocationPermission()) {
                    if (await Nearby().checkExternalStoragePermission()) {
                      if (await Nearby().checkLocationEnabled()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ftpServer()));
                      } else {
                        if (await Nearby().enableLocationServices()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ftpServer()));
                        }
                      }
                    } else {
                      Nearby().askExternalStoragePermission();
                      if (await Nearby().checkLocationEnabled()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>ftpServer()));
                      } else {
                        if (await Nearby().enableLocationServices()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ftpServer()));
                        }
                      }
                    }
                  }
                }
              },),
          IconButton(
              icon: Icon(Icons.notifications_active_outlined),
              onPressed: () => print('To imple')),
        ],
      );
    } else if (this._index == 2) {
      return AppBar(
        backgroundColor: mBackgroundColor,
        elevation: 0,
        title: Text('History'),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
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
