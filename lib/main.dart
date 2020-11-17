import 'package:chat_fx/screens/authScreen.dart';
import 'package:chat_fx/screens/chatScreen.dart';
import 'package:chat_fx/screens/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Fx',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          // ds tells flutter dt d accentColor(deep purple) is a very dark color so any other deep color sud b a bright color so we wont have a dark text on deep purple
          accentColorBrightness: Brightness.dark,
          // we want to override the default button theme so we can customize hw our buttons should look
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      home:
          /*Using the Stream builder, we check d auth state of d user and then render either the ChatScreen (if we find a valid token) or the AuthScreen.*/
          StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, userSnapshot) {
                // it takes some time for firebase to confirm if we av a token so we render a splash screen while we wait
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }
                if (userSnapshot.hasData) {
                  return ChatScreen();
                }
                return AuthScreen();
              }),
    );
  }
}
