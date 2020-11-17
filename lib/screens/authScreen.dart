import 'dart:io';

import 'package:chat_fx/widgets/auth/authForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  // ds method is called to create/login a user to firebase... it recevies needed args from authForm widget
  Future _submitAuthForm(String email, String password, String username,
      File userImageFile, bool isInLoginMode, BuildContext context) async {
    // loggin in a user
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isInLoginMode) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      //registering a new user
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // we upload the file to firebase storage
        final ref = FirebaseStorage.instance
            .ref() // returns or create a new storage to the root location
            .child(
                "user_image") // d folder name where the images will be stored
            .child(authResult.user.uid +
                '.jpg'); // d name to use for storing the image.. we r using the user id here so its easy to map images to users later

        // ds is where the image upload kicks off
        await ref.putFile(userImageFile).onComplete;

        // we get the download url to d uploaded image
        final imageUrl = await ref.getDownloadURL();

        // we then store the newly created user in 'users' collection using the user id as the document id
        await Firestore.instance
            .collection("users")
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': 'email',
          'image_url': imageUrl
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
    // on PlatformException : - i.e. error from firebase, not related to code
    on PlatformException catch (err) {
      var message = "An error occurred, please check your credentials!";
      // we check if firebase provides us with an error msg if yes we override our default error msg
      if (err.message != null) {
        message = err.message;
      }
      // we show a snackbar to display the error msg
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
    // catch general errors that are not related to firebase
    catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
