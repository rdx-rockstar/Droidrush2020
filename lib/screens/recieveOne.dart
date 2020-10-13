import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:qr_flutter/qr_flutter.dart';

//   REcieve Main APP bar
class recieveOne extends StatefulWidget {
  String userName;
  recieveOne(String uname) {
    this.userName = uname;
  }
  @override
  _recieveOneState createState() => _recieveOneState(userName);
}

class _recieveOneState extends State<recieveOne> {
  String userName;

  _recieveOneState(String uname) {
    //    Constructor
    this.userName = uname;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: AppBar(
            title: Center(
              child: Text(
                "Share Anything",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                //   qr code
                icon: Icon(Icons.qr_code),
                onPressed: () {
                  _showMyDialog();
                },
              ),
            ],
          ),
        ),
        body: recvOneBody(userName),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text("QR Code"),
              Spacer(
                flex: 2,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Center(
              child: RepaintBoundary(
                child: QrImage(
                  data: userName,
                  size: 250,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class recvOneBody extends StatefulWidget {
  String userName;
  recvOneBody(String uname) {
    //    Constructor
    this.userName = uname;
  }

  @override
  _recvOneBodyState createState() => _recvOneBodyState(userName);
}

class _recvOneBodyState extends State<recvOneBody> {
  String userName; //   username
  final mymessage = TextEditingController(); //   Sending message
  final Strategy strategy = Strategy.P2P_STAR; //   Strategy of connection (P2P)
  String cId = "0"; //   currently connected device ID
  File tempFile; //   reference to the file currently being transferred
  Map<int, String> map =
      Map(); //   store filename mapped to corresponding payloadId

  ValueNotifier<bool> _status = ValueNotifier<bool>(false);

  _recvOneBodyState(String uname) {
    //    Constructor
    this.userName = uname;
  }

  @override
  void dispose() {
    //   TextField
    // Clean up the controller when the widget is disposed.
    mymessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ValueListenableBuilder(
        builder: (BuildContext context, bool value, Widget child) {
          return Row(
            //    status display
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  height: 20.0,
                  color: value ? Colors.green : Colors.grey,
                  child:
                      Center(child: Text(value ? "Connected" : "Disconnected")),
                ),
              ),
            ],
          );
        },
        valueListenable: _status,
      ),
      Row(
        children: <Widget>[
          Container(
            child: RaisedButton(
              child: Text('Open Connection'),
              color: Colors.amber,
              onPressed: () async {
                try {
                  print("Advertisement starts");
                  bool a = await Nearby().startAdvertising(
                    userName,
                    strategy,
                    onConnectionInitiated: onrecv_ConnectionInit,
                    onConnectionResult: (id, status) {
                      print(status);
                      showSnackbar(status);
                    },
                    onDisconnected: (id) {
                      showSnackbar("Disconnected: " + id);
                    },
                  );
                  showSnackbar("ADVERTISING: " + a.toString());
                } catch (exception) {
                  showSnackbar(exception);
                }
              },
            ),
          ),
          Container(
            child: RaisedButton(
              child: Text('End Connection'),
              color: Colors.amber,
              onPressed: () async {
                await Nearby().stopAllEndpoints();
                _status.value = false;
              },
            ),
          )
        ],
      ),
      Container(
        //      Text Box
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 70.0,
        color: Colors.amber,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.attach_file),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                // file transfer
              },
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: mymessage,
                decoration:
                    InputDecoration.collapsed(hintText: 'Enter message ...'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                // mymessage text have to displayed on the main screen
                showSnackbar("Sending ${mymessage.text} to $cId");
                Nearby().sendBytesPayload(
                    cId, Uint8List.fromList(mymessage.text.codeUnits));
              },
            )
          ],
        ),
      ),
    ]);
  }

  void showSnackbar(dynamic a) {
    //    snackbar
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  void onrecv_ConnectionInit(String id, ConnectionInfo info) {
    //  on receiver side
    cId = id;
    _status.value = true;
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes);
          showSnackbar(endid + ": " + str);

          if (str.contains(':')) {
            // used for file payload as file payload is mapped as
            // payloadId:filename
            int payloadId = int.parse(str.split(':')[0]);
            String fileName = (str.split(':')[1]);

            if (map.containsKey(payloadId)) {
              if (await tempFile.exists()) {
                tempFile.rename(tempFile.parent.path + "/" + fileName);
              } else {
                showSnackbar("File doesnt exist");
              }
            } else {
              //add to map if not already
              map[payloadId] = fileName;
            }
          }
        } else if (payload.type == PayloadType.FILE) {
          showSnackbar(endid + ": File transfer started");
          tempFile = File(payload.filePath);
        }
      },
    );
  }
}
