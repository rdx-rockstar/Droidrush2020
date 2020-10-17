import 'dart:math';
import 'dart:ui';

import 'package:ShareApp/constants/color_constant.dart';
import 'package:ShareApp/models/buttontapped.dart';
import 'package:ShareApp/screens/Local_Sharing/createGrp.dart';
import 'package:ShareApp/screens/Local_Sharing/joinGrp.dart';
import 'package:ShareApp/screens/Local_Sharing/recieveOne.dart';
import 'package:ShareApp/screens/Local_Sharing/sendOne.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby_connections/nearby_connections.dart';

class Local_Sharing extends StatefulWidget {
  @override
  _Local_SharingState createState() => _Local_SharingState();
}

class _Local_SharingState extends State<Local_Sharing> {

  final String userName = Random().nextInt(10000).toString();

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
    );
  }
}
