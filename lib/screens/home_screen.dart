import 'dart:math';

import 'package:ShareApp/constants/color_constant.dart';
import 'package:ShareApp/constants/style_constant.dart';
import 'package:ShareApp/models/buttontapped.dart';
import 'package:ShareApp/screens/recieveOne.dart';
import 'package:ShareApp/screens/sendOne.dart';
import 'package:ShareApp/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ShareApp/models/button.dart';
import 'package:ShareApp/models/buttontapped.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ShareApp/screens/sharing.dart';
import 'package:nearby_connections/nearby_connections.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  void _press1() {
    // To implement this functionality to change the screen
  }

  // Unique identity for a user.
  final String userName = Random().nextInt(10000).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        elevation: 0,
        title: SvgPicture.asset(
          'assets/icons/share.svg',
          height: 50.0,
        ),
        iconTheme: new IconThemeData(color: Colors.blue),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("MiA3"),
              accountEmail: Text("fetchfrom@firebase.com"),
              currentAccountPicture: new GestureDetector(
                onTap: () => print('To implement This Function'),
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text("MiA3"),
                ),
              ),
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
      bottomNavigationBar: BottomNavigationShare(),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Center(
                child: Text('Hi Someone, or anyother text if any ',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: mTitleColor,
                        fontSize: 16)),
              ),
            ),
            SizedBox(height: 40),
            // All the Images and
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0.0, 0.2),
                            blurRadius: 6.0,
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/main.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            // Now buttons
            // Send one
            Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            if (await Nearby().checkLocationPermission()) {
                              if (await Nearby()
                                  .checkExternalStoragePermission()) {
                                if (await Nearby().checkLocationEnabled()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              sendOne(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sharing("send", userName)));
                                  }
                                }
                              } else {
                                Nearby().askExternalStoragePermission();
                                if (await Nearby().checkLocationEnabled()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              sharing("send", userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sharing("send", userName)));
                                  }
                                }
                              }
                            } else {
                              if (await Nearby().askLocationPermission()) {
                                if (await Nearby()
                                    .checkExternalStoragePermission()) {
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sharing("send", userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sharing("send", userName)));
                                    }
                                  }
                                } else {
                                  Nearby().askExternalStoragePermission();
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sharing("send", userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sharing("send", userName)));
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: ButtonTapped(icon: Icons.share),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            if (await Nearby().checkLocationPermission()) {
                              if (await Nearby()
                                  .checkExternalStoragePermission()) {
                                if (await Nearby().checkLocationEnabled()) {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => sharing("recieve",userName)));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              recieveOne(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                recieveOne(userName)));
                                  }
                                }
                              } else {
                                Nearby().askExternalStoragePermission();
                                if (await Nearby().checkLocationEnabled()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              recieveOne(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                recieveOne(userName)));
                                  }
                                }
                              }
                            } else {
                              if (await Nearby().askLocationPermission()) {
                                if (await Nearby()
                                    .checkExternalStoragePermission()) {
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                recieveOne(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  recieveOne(userName)));
                                    }
                                  }
                                } else {
                                  Nearby().askExternalStoragePermission();
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                recieveOne(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  recieveOne(userName)));
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: ButtonTapped(icon: Icons.call_received),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ends
          ],
        ),
      ),
    );
  }
}
