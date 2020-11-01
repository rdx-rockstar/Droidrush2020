import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final String userName;
  const Settings({this.userName});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showPassword = false;
  SharedPreferences sharedPreferences;
  TextEditingController nameController;
  String userName = " ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSP();
  }

  void loadSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loaduserName();
  }

  loaduserName() async {
    userName = await sharedPreferences.getString('userName');
    setState(() {});
  }

  saveuserName(String userName) async {
    sharedPreferences.setString('userName', userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/fmainJ.jpg'),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              // To buil text field
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextFormField(
                  controller: nameController,
                  obscureText: false ? showPassword : false,
                  onChanged: (val) {
                    userName = val;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      suffixIcon: false
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Full Name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: userName,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                ),
              ),
              // buildTextField("Full Name", widget.userName, false),
              // buildTextField("E-mail", "example@gmail.com", false),
              // buildTextField("Password", "********", true),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      userName = "";
                      setState(() {});
                    },
                    child: Text("CLEAR",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print(userName);
                      saveuserName(userName);
                      setState(() {});
                      FocusScope.of(context).unfocus();
                    },
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    // nameController.text = placeholder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: nameController,
        obscureText: isPasswordTextField ? showPassword : false,
        onChanged: (val) {
          nameController.text = val;
        },
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
            )),
      ),
    );
  }
}
