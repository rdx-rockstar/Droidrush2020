import 'package:flutter/material.dart';
import 'package:ShareApp/constants/color_constant.dart';
import 'package:flutter/services.dart';

class ftpServer extends StatefulWidget {

  @override
  ftpState createState() => ftpState();
}
class ftpState extends State<ftpServer> {
  static const MethodChannel _channel = MethodChannel("ftp");
  final infoctrl = TextEditingController();
  final _FormKey = GlobalKey<FormState>();
  ValueNotifier<bool> _status = ValueNotifier<bool>(false);
  String name = '';
  String password = '';
  String dir = '';

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
              if (_FormKey.currentState.validate()) {
                if (_status.value) {
                  _status.value = false;
                  check().then((value)
                      {print(value);
                      print("huu");
                      }
                  );
                  infoctrl.text="";
                }
                else {
                  try {
                    _status.value = true;
                    print(check());
                    infoctrl.text = "a\nb";
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
  static Future<String> check()async {
    return _channel.invokeMethod("check");
  }
}
