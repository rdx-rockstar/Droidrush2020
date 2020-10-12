import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:qr_flutter/qr_flutter.dart';

class sharing extends StatefulWidget {

  String type,username;
  sharing(type, uname){
    this.type = type;
    this.username = uname;
  }

  @override
  _sharingState createState() => _sharingState(this.type, this.username);
}

class _sharingState extends State<sharing> {

  String type,username;
  _sharingState(type, uname){
    this.type = type;
    this.username = uname;
  }

  @override
  Widget build(BuildContext context) {
    if(this.type=='send'){
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Send Message here'),
          ),
          body: Body(this.type, this.username),
        ),
      );
    }
    else if(this.type == 'recieve'){
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Recieve Message here'),
          ),
          body: Body(this.type, this.username),
        ),
      );
    }
  }
}

class Body extends StatefulWidget {

  String type,username;
  Body(type, uname){
    this.type = type;
    this.username = uname;
  }

  @override
  _MyBodyState createState() => _MyBodyState(this.type, this.username);
}

class _MyBodyState extends State<Body> {

  String type,userName;                              //   username and type of connection
  final mymessage = TextEditingController();         //   Sending message
  final Strategy strategy = Strategy.P2P_STAR;       //   Strategy of connection (P2P)
  String barcode = "";                               //   Text return from scanning QR code
  String cId = "0";                                  //   currently connected device ID
  File tempFile;                                     //   reference to the file currently being transferred
  Map<int, String> map = Map();                      //   store filename mapped to corresponding payloadId

  _MyBodyState(type, uname){                         //   Constructor
    this.type = type;
    this.userName = uname;
  }

  @override
  void dispose() {                                   //   TextField
    // Clean up the controller when the widget is disposed.
    mymessage.dispose();
    super.dispose();
  }

  @override                                          //   Main GUI
  Widget build(BuildContext context) {
    if(type=='send') {                               //   (GUI for Sender)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Text("User Name: " + userName),
              Text("Connected with: " + cId),
              RaisedButton(
                child: Text("Establish Connection"),
                onPressed: () async {
                  print('Scaning QR code');
                  scan();
                },
              ),
              RaisedButton(
                child: Text("Quit Connections"),
                onPressed: () async {
                  await Nearby().stopAllEndpoints();
                },
              ),
              Divider(),
              Text(
                "Sending Data",
              ),
              TextField(
                controller: mymessage,
              ),
              RaisedButton(
                child: Text("Send Message"),
                onPressed: () {
                  showSnackbar("Sending ${mymessage.text} to $cId");
                  Nearby().sendBytesPayload(cId, Uint8List.fromList(mymessage.text.codeUnits));
                },
              ),
              RaisedButton(
                child: Text("Send File"),
                onPressed: () async {
                  File file =
                  await ImagePicker.pickImage(source: ImageSource.gallery);

                  if (file == null) return;

                  int payloadId = await Nearby().sendFilePayload(cId, file.path);
                  showSnackbar("Sending file to $cId");
                  Nearby().sendBytesPayload(
                      cId,
                      Uint8List.fromList(
                          "$payloadId:${file.path.split('/').last}".codeUnits));
                },
              ),
            ],
          ),
        ),
      );
    }
    else if(this.type == 'recieve'){               //    (GUI for receiver)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Text("User Name: " + userName),
              RaisedButton(
                child: Text("Recive Data"),
                onPressed: () async {
                  try {
                    bool a = await Nearby().startAdvertising(
                      userName,
                      strategy,
                      onConnectionInitiated: onrecv_ConnectionInit,
                      onConnectionResult: (id, status) {
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
              RaisedButton(
                child: Text("Quit Connection"),
                onPressed: () async {
                  await Nearby().stopAllEndpoints();
                },
              ),
              Divider(),
              Text("Sending Data",),
              TextField(controller: mymessage,),
              RaisedButton(
                child: Text("Send Message"),
                onPressed: () async {
                  String a = Random().nextInt(100).toString();
                  showSnackbar("Sending ${mymessage.text} to $cId");
                  Nearby().sendBytesPayload(cId, Uint8List.fromList(mymessage.text.codeUnits));
                },
              ),
              RaisedButton(
                child: Text("Send File Payload"),
                onPressed: () async {
                  File file =
                  await ImagePicker.pickImage(source: ImageSource.gallery);

                  if (file == null) return;

                  int payloadId = await Nearby().sendFilePayload(cId, file.path);
                  showSnackbar("Sending file to $cId");
                  Nearby().sendBytesPayload(
                      cId,
                      Uint8List.fromList(
                          "$payloadId:${file.path.split('/').last}".codeUnits));
                },
              ),
              Expanded(                             //    QR CODE
                child:  Center(
                  child: RepaintBoundary(
                    child: QrImage(
                      data: userName,
                      size: 400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );;
    }
  }

  Future scan() async {                       //    scan QR code
    try {
      ScanResult result = await BarcodeScanner.scan();
      if(result.type == ResultType.Barcode) {
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
            if(name == barcode){
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
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void showSnackbar(dynamic a) {                   //    snackbar
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {     // on sender side
    cId = id;
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
                tempFile.rename(
                    tempFile.parent.path + "/" + fileName);
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
        if (payloadTransferUpdate.status ==
            PayloadStatus.IN_PROGRRESS) {
          print('Payload is in progress');
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status ==
            PayloadStatus.FAILURE) {
          print("failed");
          showSnackbar(endid + ": FAILED to transfer file");
        } else if (payloadTransferUpdate.status ==
            PayloadStatus.SUCCESS) {
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

  void onrecv_ConnectionInit(String id, ConnectionInfo info) {      //  on receiver side
    cId = id;
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
                tempFile.rename(
                    tempFile.parent.path + "/" + fileName);
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
