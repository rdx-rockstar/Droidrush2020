import 'package:flutter/material.dart';
import 'package:ShareApp/constants/color_constant.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ftpServer extends StatefulWidget {

  @override
  ftpState createState() => ftpState();
}
class ftpState extends State<ftpServer> {
  static const MethodChannel _channel = MethodChannel("ftp");
  final infoctrl = TextEditingController();
  final _FormKey = GlobalKey<FormState>();
  ValueNotifier<bool> _status = ValueNotifier<bool>(false);
  static String name = '';
  static String password = '';
  static String dir = '';
  ftpState(){
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
                  _status.value = false;
                  start().then((value)
                      {if(value==0){
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
                          msg: "error1",
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
                    _status.value = true;
                    start().then((value){
                      if(value==1){
                        Fluttertoast.showToast(
                          msg: "server started",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16,
                        );
                        String w,m;
                        mad().then((value) => m=value);
                        wad().then((value) => w=value);
                        infoctrl.text = "search adresses:\n for mac:"+m+"\n for others:"+w;
                      }
                      else if(value==-1){
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
                          msg: "error0",
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
                                enabled: !_status.value,
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
                                enabled: !_status.value,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password', labelText: 'Password'),
                                validator: (val) => val.length < 6
                                    ? 'Enter a password atleast chars long'
                                    : null,
                                onChanged: (val) {
                                  password=val;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                  maxLines: 6,
                                enabled: false,
                                controller:infoctrl,
                              ),
                              IconButton(icon: Icon(Icons.android),
                                  color: Colors.greenAccent, onPressed:  () {
                                _channel.invokeMethod("test").then((value){
                                  Fluttertoast.showToast(
                                    msg: value,
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16,
                                  );
                                });
                              })
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
  static Future<int> start()async {

    return _channel.invokeMethod("start",<String, dynamic>{
      's': name,
      'p': password,
      'l': dir,
    });
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
