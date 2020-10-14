import 'dart:io';
import 'dart:typed_data';

import 'package:ShareApp/models/message_model.dart';
import 'package:ShareApp/models/try_switch.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

//   REcieve Main APP bar

String cId = "0";
final mymessage = TextEditingController();
ValueNotifier<bool> _status = ValueNotifier<bool>(false);
List<Message> messages = [
  Message(
    sender: 'Admin',
    text: 'You Can Start You Conversation Here..',
  ),
];

class sendOne extends StatefulWidget {
  String userName;
  sendOne(String uname) {
    this.userName = uname;
  }
  @override
  _sendOneState createState() => _sendOneState(userName);
}

class _sendOneState extends State<sendOne> {
  String userName;
  String barcode = "";

  _sendOneState(String uname) {
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

  // this is the chat bubble function which is ok till now
  _chatbubble(Message message, bool isMe) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration:
                      BoxDecoration(color: Colors.blue[100], boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ]),
                  child: Text(message.text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(message.sender),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.topRight,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration:
                      BoxDecoration(color: Colors.blue[100], boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ]),
                  child: Text(message.text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(message.sender),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      );
    }
  }
  // End of the chat bubble function till now it is right

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            centerTitle: true,
            title: Text(
              "Send Anything",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0.0,
          ),
        ),
        // end of app bar which is good to go
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
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
                          child: Center(
                              child:
                                  Text(value ? "Connected" : "Disconnected")),
                        ),
                      ),
                    ],
                  );
                },
                valueListenable: _status,
              ),
              // Now this is the sendOne body class call which creates the start and end fucntion and scan too
              sendOneBody(userName, barcode),
              // this is the list of all messages from list view builder
              Expanded(
                child: Container(
                  child: buildListView(),
                ),
              ),
              // End of all messages section which is created
              // Now this is the bottom send message text controller
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: 60.0,
                color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo),
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
                        decoration: InputDecoration.collapsed(
                            hintText: 'Enter message ...'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 25.0,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Message n = new Message();
                        n.sender = cId;
                        n.text = mymessage.text;
                        print(mymessage.text);
                        if (_status.value) {
                          setState(() {
                            messages.add(n);
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: "The Device is Disconnected",
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16,
                          );
                        }
                        // showSnackbar("Sending ${mymessage.text} to $cId");
                        Nearby().sendBytesPayload(
                            cId, Uint8List.fromList(mymessage.text.codeUnits));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // body: SingleChildScrollView(
        //   child: sendOneBody(userName, barcode),
        // ),
        // body: sendOneBody(userName, barcode),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      reverse: false,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        bool isMe = true;
        return _chatbubble(messages[index], isMe);
      },
    );
  }
}

class sendOneBody extends StatefulWidget {
  String userName;
  String barcode;
  sendOneBody(String uname, String barcode) {
    //    Constructor
    this.userName = uname;
    this.barcode = barcode;
  }

  @override
  _sendOneBodyState createState() => _sendOneBodyState(userName, this.barcode);
}

class _sendOneBodyState extends State<sendOneBody> {
  // List<Message> messages;
  String userName; //   username
  // final mymessage = TextEditingController(); //   Sending message
  final Strategy strategy = Strategy.P2P_STAR; //   Strategy of connection (P2P)
  // String cId = "0"; //   currently connected device ID
  File tempFile; //   reference to the file currently being transferred
  Map<int, String> map =
      Map(); //   store filename mapped to corresponding payloadId
  String barcode; //   endpoint name scanned from barcode

  // ValueNotifier<bool> _status = ValueNotifier<bool>(false);

  _sendOneBodyState(String uname, String brcode) {
    //    Constructor
    this.userName = uname;
    this.barcode = brcode;
  }

  @override
  void dispose() {
    //   TextField
    // Clean up the controller when the widget is disposed.
    // mymessage.dispose();
    super.dispose();
  }

  void showSnackbar(dynamic a) {
    //    snackbar
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
// THIS IS THE FUNCTION TO CREATE ALL CHAT DYNAMICALLY

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          // SizedBox(width: 80),
          Expanded(
            child: Container(
              child: RaisedButton(
                child: Text('Start Connection'),
                color: Colors.amber,
                onPressed: () async {
                  scan();
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: RaisedButton(
                child: Text('End Connection'),
                color: Colors.amber,
                onPressed: () async {
                  await Nearby().stopDiscovery();
                  await Nearby().stopAllEndpoints();
                  _status.value = false;
                },
              ),
            ),
          )
        ],
      ),
    ]);
  }

  Future scan() async {
    //    scan QR code
    try {
      ScanResult result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        setState(() => this.barcode = result.rawContent);
      }
      print('QR code Scanned');
      try {
        bool a = await Nearby().startDiscovery(
          userName,
          strategy,
          onEndpointFound: (id, name, serviceId) async {
            // show sheet automatically to request connection
            print(barcode);
            print(name);
            if (name == barcode) {
              print(id);
              Nearby().requestConnection(
                userName,
                id,
                onConnectionInitiated: (id, info) {
                  onConnectionInit(id, info);
                },
                onConnectionResult: (id, status) {
                  showSnackbar(status);
                },
                onDisconnected: (id) {
                  showSnackbar(id);
                },
              );
            }
          },
          onEndpointLost: (id) {
            showSnackbar("Lost Endpoint:" + id);
          },
        );
        showSnackbar("DISCOVERING: " + a.toString());
      } catch (e) {
        showSnackbar(e);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  // void showSnackbar(dynamic a) {
  //   //    snackbar
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text(a.toString()),
  //   ));
  // }

  void onConnectionInit(String id, ConnectionInfo info) {
    // on sender side
    cId = id;
    _status.value = true;
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes);
          showSnackbar(endid + ": " + str);
          Message m = new Message();
          m.sender = endid;
          m.text = str;
          messages.add(m);
          setState(() {});
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
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRRESS) {
          print('Payload is in progress');
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print("failed");
          showSnackbar(endid + ": FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          showSnackbar(
              "success, total bytes = ${payloadTransferUpdate.totalBytes}");

          if (map.containsKey(payloadTransferUpdate.id)) {
            //rename the file now
            String name = map[payloadTransferUpdate.id];
            tempFile.rename(tempFile.parent.path + "/" + name);
          } else {
            //bytes not received till yet
            map[payloadTransferUpdate.id] = "";
          }
        }
      },
    );
  }
}
