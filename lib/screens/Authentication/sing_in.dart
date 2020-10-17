import 'package:ShareApp/screens/Authentication/Loading.dart';
import 'package:ShareApp/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggelView;
  SignIn({this.toggelView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password='';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :  Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              widget.toggelView();
            },
          )
        ],
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  // get email....
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                validator: (val) => val.length < 6 ? 'Enter a password 6 chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  // get password....
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                  child: Text('Sign In'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true );
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() => error = 'Could not sing in with those credentials' );
                        loading = false;
                      }
                    }
                  }
              ),
              SizedBox(height: 20.0,),
              Text(error,),
            ],
          ),
        ),
      ),
    );
  }
}
