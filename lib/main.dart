import 'package:ShareApp/screens/home_screen.dart';
import 'package:ShareApp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FirstTimeUser/main.dart';
import 'services/onBoardScreen.dart';

// setVisiting() async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   sharedPreferences.setBool('first', true);
// }

// getVisiting() async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   bool visiting = sharedPreferences.getBool('first') ?? false;
//   return visiting;
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Digital Shareing App',
        home: HomeScreen(),
      ),
    );
  }
}
