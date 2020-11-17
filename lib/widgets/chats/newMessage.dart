import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = new TextEditingController();

  Future _sendMessage() async {
    // close the keyboard
    FocusScope.of(context).unfocus();
    // we get access to the logged in user
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();
    // we add a new message to the 'chat' collection using the same 'text' key
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp
          .now(), // d time d msg was created.. we will use this to ensure the ordering of the msg is from recent to oldest
      'userId': user
          .uid, // d id of the user dt send the msg.. ds will b use to align the msg on the list
      // we also store the username of the user dt created d msg
      'username': userData.data["username"],
      // we also store the image_url of the user dt creates d msg
      'userImage': userData.data['image_url']
    });
    // we clear our input field
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            controller: _controller,
            decoration: InputDecoration(labelText: "Send a message..."),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            // disable the button until a msg is entered
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
