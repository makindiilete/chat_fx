import 'package:chat_fx/widgets/chats/messages.dart';
import 'package:chat_fx/widgets/chats/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // When the chat screen is initialized, we asked for permission to send push notification from iOS users...
  // ds will do nothing on android bcos its not required...
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    // inside d configure(), u can configure d run any code e.g. navigate the user to another pay, show dialogs etc
    fbm.configure(
        // Ds is called if the app is actively running and opened
        onMessage: (msg) {
      print("onMessage");
      print(msg);
      return;
    },
        // ds will b called if d app was terminated b4 d notification arrives
        onLaunch: (msg) {
      print("onLaunch");
      print(msg);
      return;
    },
        // Ds is called if the app is actively running but its not the current active app on the screen
        onResume: (msg) {
      print("onResume");
      print(msg);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: <Widget>[
          DropdownButton(
            // ds fixed and remove the underline showing under our dropdown menu icon
            underline: Container(),
            // items : - d items to b shown when the dropdown button is clicked
            items: [
              // each item in the list is a DropdownMenuItem which d child can then b any widget
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout")
                    ],
                  ),
                ),
                // ds uniquely identify each menu item
                value: 'logout',
              )
            ],
            // a function to call when any of our menu item is pressed
            onChanged: (identifier) {
              if (identifier == 'logout') {
                //log out the user
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // list of all messages
            // Messages widget is a list view and list view does not work inside a column unless its wrapped with Expanded
            Expanded(child: Messages()),
            // input field and button to send a new msg
            NewMessage()
          ],
        ),
      ),
    );
  }
}
