import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ShareApp/constants/color_constant.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class ftpServer extends StatefulWidget {

  @override
  ftpState createState() => ftpState();
}
class ftpState extends State<ftpServer> {
  static const MethodChannel _channel = MethodChannel("ftp");
  static String w,m;
  static int c=0;
  final infoctrl = TextEditingController();
  final dirctrl = TextEditingController();
  final _FormKey = GlobalKey<FormState>();
  ValueNotifier<bool> _status = ValueNotifier<bool>(false);
  static String name = '';
  static String password = '';
  static String dir = '/storage/emulator/0/';
  static String temp="";
  ftpState(){
    c=0;
    stop().then((value){});
    dirctrl.text="/storage/emulator/0/";
    create().then((value){
      if(value==1){
        Fluttertoast.showToast(
          msg: "server created",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16,
        );
      }
      else{
        Fluttertoast.showToast(
          msg: "server not created",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16,
        );
      }
    });
  }
  @override
  void dispose() {
    stop().then((value){
      if(value==1){
        Fluttertoast.showToast(
          msg: "server stopped",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16,
        );
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FTP Server'),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new_outlined, color: Colors.white),
            onPressed: () {

//            _channel.invokeMethod("test").then((value){
//    Fluttertoast.showToast(
//                          msg: value,
//                          toastLength: Toast.LENGTH_LONG,
//                          backgroundColor: Colors.white,
//                          textColor: Colors.black,
//                          fontSize: 16,
//                        );
//    });
//    }
              if (_FormKey.currentState.validate()) {
                if (_status.value) {

                  start().then((value)
                      {if(value=="0"){
                        _status.value = false;
                        Fluttertoast.showToast(
                          msg: "succesfully suspended",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16,
                        );
                        infoctrl.text = "";
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Storage Permissions Denied",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16,
                        );
                      }
                      }
                  );
                  infoctrl.text="";
                }
                else {
                  try {

                    start().then((value){
                      if(value=="1"||value=="2"){
                        _status.value = true;
                        if(value=="1"){
                          c=1;
                        Fluttertoast.showToast(
                          msg: "server started",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16,
                        );}
                        else{
                          Fluttertoast.showToast(
                            msg: "server resumed",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16,
                          );
                        }

                        mad().then((value) {
                        m=value.toString();
                        wad().then((value)  {
                          w=value.toString();
                          infoctrl.text = "Server Hosted at: \n\nFor mac: "+m.toString()+" \n\nFor others: "+w.toString();
                        });
                        });

                      }
                      else if(value=="-1"){
                        Fluttertoast.showToast(
                          msg: "connect wifi or hotspot",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16,
                        );
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Storage Permissions Denied",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16,
                        );
                      }
                    });
                  }
                  catch(Exception){

                  }
                }
                setState(() {
                });

              }
            },
          )
        ],
      ),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: ValueListenableBuilder(
                  builder: (BuildContext context, bool value, Widget child) {
                    return Row(
                      //    status display
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            height: 30.0,
                            color: value ? Colors.lightGreen: Colors.grey,
                            child: Center(
                                child:
                                Text(value ? "Server Hosted" : "Disconnected")),
                          ),
                        ),
                      ],
                    );
                  },
                  valueListenable: _status,
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                      child: Form(
                        key: _FormKey,
                        child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                enabled: c==0,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Name', labelText: 'Name'),
                                validator: (val) =>
                                val.isEmpty ? 'Enter an name' : null,
                                onChanged: (val) {
                                  name=val;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                enabled: c==0,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password', labelText: 'Password'),
                                validator: (val) => val.length < 3
                                    ? 'Enter a password atleast 3 chars long'
                                    : null,
                                onChanged: (val) {
                                  password=val;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.home),
                                      color:Colors.greenAccent,
                                      focusColor: Colors.blue,
                                      iconSize: 25.0,
                                      onPressed: () async {
                                        dir = await FilePicker.getDirectoryPath()+"/";
                                        dirctrl.text=dir;
                                      },
                                    ),
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        textCapitalization: TextCapitalization.sentences,
                                        controller:dirctrl,
                                      ),
                                    ),
                                  ]
                              ),

                              TextFormField(
                                  maxLines: 6,
                                enabled: false,
                                controller:infoctrl,
                              ),
                              IconButton(icon: Icon(Icons.perm_device_information),
                                  color: Colors.greenAccent, onPressed:  ()async {
                                    var dir = await getExternalStorageDirectory();
                                    var status = await Permission.storage.status;
                                    if (!status.isGranted) {
                                      print("permission not granted 1.0");
                                      await Permission.storage.request();
                                    }
                                    else{
                                      ask_permissions();
                                        if (!File(
                                            "/storage/emulated/0/test.txt")
                                            .existsSync()) {
                                          try {
                                            File("/storage/emulated/0/test.txt")
                                                .createSync(recursive: true);
                                            Fluttertoast.showToast(
                                              msg: "permissions allowed",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              fontSize: 16,
                                            );
//                                        PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
//                                        if (permissionResult == PermissionStatus.authorized){
//                                          // code of read or write file in external storage (SD card)
//                                        }
                                          }
                                          catch (e) {
                                            print(e);
                                            Fluttertoast.showToast(
                                              msg: "permission not granted 1.1",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              fontSize: 16,
                                            );
                                          }
                                        }
                                        else {
                                          try {
                                            File(
                                                "/storage/emulated/0/lol/lol.txt")
                                                .writeAsString(
                                                "testing permissions//share it");
                                            Fluttertoast.showToast(
                                              msg: "permissions allowed",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              fontSize: 16,
                                            );
                                          }
                                          catch (e) {
                                            print(e);
                                            Fluttertoast.showToast(
                                              msg: "permission not granted 1.2",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              fontSize: 16,
                                            );
                                          }
                                        }
                                    }
                                  }),
                            ]
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
    );
  }
  ////INVOKE MEATHODS
  static Future<int> create()async {
    return _channel.invokeMethod("create");
  }
  static Future<String> start()async {
    return _channel.invokeMethod("start",<String, dynamic>{
      'u': name,
      'p': password,
      'l': dir,
    });
  }
  static void ask_permissions()async{
    return _channel.invokeMethod("permissions");
  }
  static Future<int> stop()async {
    return _channel.invokeMethod("stop");
  }
  static Future<String> wad()async {
    return _channel.invokeMethod("wad");
  }
  static Future<String> mad()async {
    return _channel.invokeMethod("mad");
  }
}
