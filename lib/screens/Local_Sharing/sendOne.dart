import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:ShareApp/models/message_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ShareApp/screens/Local_Sharing/apk_list.dart';
import 'package:ShareApp/screens/Local_Sharing/paths_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ShareApp/models/add_history.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
//   Recieve Main APP bar

String cId = "0";
String Reciver_name="";
var timer;
final mymessage = TextEditingController();
Map<String, String> _paths;
ValueNotifier<bool> _status = ValueNotifier<bool>(false);
ValueNotifier<bool> _isSearching = ValueNotifier<bool>(false);

class sendOne extends StatefulWidget {
  String userName;
  sendOne(String uname) {
    print(uname+" s0");
    this.userName = uname;
  }
  @override
  _sendOneState createState() => _sendOneState(userName);
}

class _sendOneState extends State<sendOne> {
  File tempFile;
  final Strategy strategy =
      Strategy.P2P_POINT_TO_POINT; //   Strategy of connection (P2P)
  Map<int, String> map =
      Map(); //   store filename mapped to corresponding payloadId
  String userName;
  String barcode = "";
  List<Message> _messages = [
    Message(
      sender: 'Admin',
      text: 'You Can Start You Conversation..',
    ),
  ];
  _sendOneState(String uname) {
    //    Constructor
    this.userName = uname;
    print(uname+" send");
  }
  // List to save data
  List<SaveData> check = [];
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSP();
  }
  loaduserName() async {
    userName = await sharedPreferences.getString('userName');
    print(userName+" ss");
  }
  // LOADING THE SHARED PREFERENCES
  void loadSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      saveData();
    });
  }

  // AND SAVING THE DATA TO SHAREDPREFERENCES
  void saveData() {
    List<String> spList = check.map((e) => jsonEncode(e.toMap())).toList();
    sharedPreferences.setStringList('check', spList);
  }

  // TO SAVE THE DATA IN check LIST OF SAVEDATA TYPE
  void appendList(String fileName, String whichSide, String otherUserId) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    check.add(
      SaveData(
          fileName: fileName,
          whichSide: whichSide,
          dateTime: formattedDate,
          otherUserId: otherUserId),
    );
    saveData();
  }

  @override
  Future<void> dispose() async {
    //   TextField
    try {
      await Nearby().stopAllEndpoints();
      try {
        await Nearby().stopDiscovery();
        timer.cancel();
      }
      catch(e){}
    }
    catch(e){
      try {
        await Nearby().stopDiscovery();
        timer.cancel();
      }
      catch(e){}
    }
    _isSearching.value=false;
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
    loaduserName();
    /*
    // CODE TO SAVE DATA MAUNUALLY
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Send",
        dateTime: formattedDate,
        otherUserId: "This"));
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Send",
        dateTime: formattedDate,
        otherUserId: "This"));
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Send",
        dateTime: formattedDate,
        otherUserId: "This"));
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Send",
        dateTime: formattedDate,
        otherUserId: "This"));
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Send",
        dateTime: formattedDate,
        otherUserId: "This"));
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Snd",
        dateTime: formattedDate,
        otherUserId: "This"));
    check.add(SaveData(
        fileName: "sendOne",
        whichSide: "Send",
        dateTime: formattedDate,
        otherUserId: "This"));
    saveData();
    */

    appendList("This is a just Dummy message", "Send", "ng67e");
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
              "Sender",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.qr_code_scanner),
                onPressed: () {
                  scan();
                },
              ),
              IconButton(
                icon: Icon(Icons.android_outlined),
                onPressed: () {
                  getapkpaths();
                },
              )
            ],
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
              ValueListenableBuilder(
                builder: (BuildContext context, bool value, Widget child) {
                  return Row(
                    //    status display
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          height: 20.0,
                          color: value ? Colors.green : Colors.white,
                          child: Center(
                              child:
                              Text(value ? "Searching" : "")),
                        ),
                      ),
                    ],
                  );
                },
                valueListenable: _isSearching,
              ),
              // Now this is the sendOne body class call which creates the start and end fucntion and scan too
              Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    // SizedBox(width: 80),
                    Expanded(
                      child: Container(
                        child: RaisedButton(
                          child: Text(_status.value ? "Disconnect" :(_isSearching.value? "Stop Seaching":'Search Connections')),
                          color: Colors.amber,
                          onPressed: () async {
                            if(_status.value){
                              await Nearby().stopAllEndpoints();
                              Fluttertoast.showToast(
                                  msg: "Disconnecting",
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16,
                                );
                                _status.value = false;
                            }
                            else{
                            if (_isSearching.value == false) {
                              _isSearching.value=true;
                              startTimer();
                              Fluttertoast.showToast(
                                msg: "Searching",
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16,
                              );
                              discovering(0);
                            } else {
                              await Nearby().stopDiscovery();
                              _isSearching.value=false;
                              try{
                                timer.cancel();
                                print("timer cancelled");
                              }
                              catch(e){};
                            }
                            }
                            setState(() {
                            });
                          },
                        ),
                      ),
                    ),
//                    Expanded(
//                      child: Container(
//                        child: RaisedButton(
//                          child: Text('End Connection'),
//                          color: Colors.amber,
//                          onPressed: () async {
//                            await Nearby().stopDiscovery();
//                            _isSearching.value=false;
//                            try{
//                              timer.cancel();
//                              print("timer cancelled");
//                            }
//                            catch(e){
//                              print(e);
//                            }
//                            await Nearby().stopAllEndpoints();
//                            if (_status.value == false && _isSearching.value== true) {
//                              _isSearching.value = false;
//                              Fluttertoast.showToast(
//                                msg: "Search Stopped ",
//                                backgroundColor: Colors.white,
//                                textColor: Colors.black,
//                                fontSize: 16,
//                              );
//                            } else if (_status.value == true) {
//                              Fluttertoast.showToast(
//                                msg: "Disconnecting",
//                                backgroundColor: Colors.white,
//                                textColor: Colors.black,
//                                fontSize: 16,
//                              );
//                              _status.value = false;
//                            }
//                          },
//                        ),
//                      ),
//                    )
                  ],
                ),
              ]),
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
                      onPressed: () async {
                        _paths = await FilePicker.getMultiFilePath();
                        if(_paths.length>0) {
                          Fluttertoast.showToast(
                            msg: "click send to send files",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16,
                          );
                        }
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
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        if (_paths != null) {
                          for (int i = 0; i < _paths.length; i++) {
                            int payloadId = await Nearby().sendFilePayload(
                                cId, _paths.values.toList()[i]);
                            Message n = new Message();
                            String s =
                                "Sending ${_paths.keys.toList()[i]} to $Reciver_name";
                            n.text = s;
                            n.sender = userName;
                            _messages.add(n);
                            appendList(_paths.keys.toList()[i], "Send", cId);
                            Nearby().sendBytesPayload(
                                cId,
                                Uint8List.fromList(
                                    "$payloadId:${_paths.values.toList()[i].split('/').last}"
                                        .codeUnits));
                          }
                          _paths = null;
                        }
                        Message n = new Message();
                        n.sender = userName;
                        n.text = mymessage.text;
                        print(mymessage.text);
                        if (n.text != "") {
                          Nearby().sendBytesPayload(cId,
                              Uint8List.fromList(mymessage.text.codeUnits));
                          if (_status.value) {
                            setState(() {
                              _messages.add(n);
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: "The Device is Disconnected",
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16,
                            );
                          }
                        }
                        mymessage.clear();
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

  void getapkpaths() async {
    final dataFromSecondPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApkExtractor()),
    ) as Data;
    _paths = dataFromSecondPage.path;
    print(_paths);
    Fluttertoast.showToast(
      msg: "click send to send apk",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16,
    );
  }

  // THIS IS THE FUNCTION TO CREATE ALL CHAT DYNAMICALLY
  ListView buildListView() {
    return ListView.builder(
      reverse: false,
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int index) {
        bool isMe = !(Reciver_name == _messages[index].sender);
        return _chatbubble(_messages[index], isMe);
      },
    );
  }

  Future scan() async {
    //    scan QR code
    try {
      ScanResult result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        setState(() => this.barcode = result.rawContent);
      }
      print('QR code Scanned');
      _isSearching.value=true;
      setState(() {

      });
      discovering(1);
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
  void startTimer(){
    timer=Timer(Duration(seconds: 30), () async {
      if(_status.value==false){
        await Nearby().stopDiscovery();
        _isSearching.value=false;
        setState(() {

        });
        Fluttertoast.showToast(
          msg: "search timed out",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16,
        );
      }
    });
  }
  Future<void> discovering(int r) async {
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) async {
          // show sheet automatically to request connection
          if (r == 1) {
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
                  if (status.toString() == "Status.CONNECTED") {
                    _messages = [
                      Message(
                        sender: 'Admin',
                        text: 'You Can Start You Conversation Here..',
                      ),
                    ];
                    _isSearching.value=false;
                    _status.value = true;
                    setState(() {

                    });
                    try{
                      Nearby().stopDiscovery();
                      timer.cancel();
                      print("timer cancelled");
                    }
                    catch(e){
                      print(e);
                    }
                  }
                  Fluttertoast.showToast(
                    msg: "" + status.toString(),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16,
                  );
                  //showSnackbar(status);
                },
                onDisconnected: (id) {
                  _status.value = false;
                  setState(() {

                  });
                  Fluttertoast.showToast(
                    msg: "Disconnected",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16,
                  );
                  //showSnackbar(id);
                },
              );
            }
          } else {
            showModalBottomSheet(
              context: context,
              builder: (builder) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text("id: " + id),
                      Text("Name: " + name),
                      Text("ServiceId: " + serviceId),
                      RaisedButton(
                        child: Text("Request Connection"),
                        onPressed: () {
                          Navigator.pop(context);
                          Nearby().requestConnection(
                            userName,
                            id,
                            onConnectionInitiated: (id, info) {
                              onConnectionInit(id, info);
                            },
                            onConnectionResult: (id, status) {
                              if (status.toString() == "Status.CONNECTED") {
                                _messages = [
                                  Message(
                                    sender: 'Admin',
                                    text: 'You Can Start You Conversation Here..',
                                  ),
                                ];
                                _status.value = true;
                                _isSearching.value=false;
                                setState(() {
                                });
                                try{
                                  Nearby().stopDiscovery();
                                  timer.cancel();
                                  print("timer cancelled");
                                }
                                catch(e){
                                  print(e);
                                }
                              }
                              Fluttertoast.showToast(
                                msg: status.toString(),
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16,
                              );
                              //showSnackbar(status);
                            },
                            onDisconnected: (id) {
                              _status.value = false;
                              setState(() {

                              });
                              Fluttertoast.showToast(
                                msg: "Disconnected",
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16,
                              );
                              //showSnackbar(id);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        onEndpointLost: (id) {
          //showSnackbar("Lost Endpoint:" + id);
        },
      );
      // showSnackbar("DISCOVERING: " + a.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

   void showSnackbar(dynamic a) {
     //    snackbar
     Scaffold.of(context).showSnackBar(SnackBar(
       content: Text(a.toString()),
     ));
   }

  void onConnectionInit(String id, ConnectionInfo info) {
    cId = id;
    Reciver_name=info.endpointName;
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes);
          Message m = new Message();
          m.sender = Reciver_name;
          m.text = str;
          _messages.add(m);
          setState(() {

          });
          //showSnackbar(endid + ": " + str);

          if (str.contains(':')) {
            int payloadId = int.parse(str.split(':')[0]);
            String fileName = (str.split(':')[1]);
            print(payloadId.toString()+" "+fileName);
            print(tempFile.parent.path );
            if (map.containsKey(payloadId)) {
              print("got map");
              if (await tempFile.exists()) {
                if(!Directory("/storage/emulated/0/DiGiShare").existsSync()){
                  try {
                    Directory("/storage/emulated/0/DiGiShare")
                        .createSync(recursive: true);}
                  catch (e){
                    Fluttertoast.showToast(
                      msg: "storage permissions not allowed",
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16,
                    );
                  }
                }
                if(!Directory("/storage/emulated/0/DiGiShare/Received").existsSync()){
                  try {
                    Directory("/storage/emulated/0/DiGiShare/Received")
                        .createSync(recursive: true);}
                  catch (e){
                    Fluttertoast.showToast(
                      msg: "storage permissions not allowed",
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16,
                    );
                  }
                }
                tempFile.rename("/storage/emulated/0/DiGiShare/Received/" + fileName);
                print("in 1 received");
              } else {
                showSnackbar("File doesnt exist");
              }
            } else {
              //add to map if not already
              print("no map1");
              map[payloadId] = fileName;
            }
          }
        } else if (payload.type == PayloadType.FILE) {
          //showSnackbar(endid + ": File transfer started");
          tempFile = File(payload.filePath);
        }
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRRESS) {
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print("failed");
          showSnackbar(endid + ": FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          print("kkk ssucc");
//          showSnackbar(
//              "bytes received = ${payloadTransferUpdate.totalBytes}");
//          setState(() {
//          });
          print("kkk ssucc");
          if(map.containsKey(payloadTransferUpdate.id)){
          print("kkk in");
            //rename the file now
            print("in 2 received");
            String name = map[payloadTransferUpdate.id];
            if(!Directory("/storage/emulated/0/DiGiShare").existsSync()){
              try {
                Directory("/storage/emulated/0/DiGiShare")
                    .createSync(recursive: true);}
              catch (e){
                Fluttertoast.showToast(
                  msg: "storage permissions not allowed",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16,
                );
              }
            }
            if(!Directory("/storage/emulated/0/DiGiShare/Received").existsSync()){
              try {
                Directory("/storage/emulated/0/DiGiShare/Received")
                    .createSync(recursive: true);}
              catch (e){
                Fluttertoast.showToast(
                  msg: "storage permissions not allowed",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16,
                );
              }
            }
            tempFile.rename("/storage/emulated/0/DiGiShare/Received/" + name);
          } else{
            print("kkk out");
            //bytes not received till yet
            map[payloadTransferUpdate.id] = "";
          }
        }
      },
    );
  }
}
