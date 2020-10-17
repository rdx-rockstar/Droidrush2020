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
<<<<<<< HEAD
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        elevation: 0,
        title: SvgPicture.asset(
          'assets/icons/share.svg',
          height: 50.0,
        ),
        iconTheme: new IconThemeData(color: Colors.red),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => print('To imple')),
        ],
      ),
=======
      appBar: appbar.getAppBar(),
>>>>>>> 3543f509f39c5f5a9ff87a5d7f5177580b79e696
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
<<<<<<< HEAD
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
            SizedBox(height: 50),
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
                                                sendOne(userName)));
                                  }
                                }
                              } else {
                                Nearby().askExternalStoragePermission();
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
                                                sendOne(userName)));
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
                                                sendOne(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sendOne(userName)));
                                    }
                                  }
                                } else {
                                  Nearby().askExternalStoragePermission();
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sendOne(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sendOne(userName)));
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
                        Expanded(
                            child: GestureDetector(
                          // ON TAP FUCNTION FOR JOIN A GROUP
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
                                              joinGrp(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                joinGrp(userName)));
                                  }
                                }
                              } else {
                                Nearby().askExternalStoragePermission();
                                if (await Nearby().checkLocationEnabled()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              joinGrp(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                joinGrp(userName)));
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
                                                joinGrp(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  joinGrp(userName)));
                                    }
                                  }
                                } else {
                                  Nearby().askExternalStoragePermission();
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                joinGrp(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  joinGrp(userName)));
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: ButtonTapped(icon: Icons.group_add_rounded),
                        )),
                        Expanded(
                            child: GestureDetector(
                          //  on tap function for join the group
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
                                              createGrp(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                createGrp(userName)));
                                  }
                                }
                              } else {
                                Nearby().askExternalStoragePermission();
                                if (await Nearby().checkLocationEnabled()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              createGrp(userName)));
                                } else {
                                  if (await Nearby().enableLocationServices()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                createGrp(userName)));
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
                                                createGrp(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  createGrp(userName)));
                                    }
                                  }
                                } else {
                                  Nearby().askExternalStoragePermission();
                                  if (await Nearby().checkLocationEnabled()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                createGrp(userName)));
                                  } else {
                                    if (await Nearby()
                                        .enableLocationServices()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  createGrp(userName)));
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: ButtonTapped(icon: Icons.add_box_rounded),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ends
=======
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
>>>>>>> 3543f509f39c5f5a9ff87a5d7f5177580b79e696
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
