import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'messageBubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        /*FutureBuilder : - Creates a widget that builds itself based on the latest snapshot of interaction with a Future/Async request
          We are using it here bcos we need to get the userId of the logged in user and then make use of it inside the ListView.builder() and gettign the userId takes an async request.*/
        FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          // we create a new collection on firestore and name it 'chat' so we can then make use of it here
          stream: Firestore.instance
              .collection('chat')
              .orderBy("createdAt",
                  descending:
                      true) // we order the msgs by the time they were created
              .snapshots(),
          builder: (context, chatSnapShot) {
            if (chatSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var chatDocs = chatSnapShot.data.documents;
            return ListView.builder(
              // instead of having the messages starting from the top of the screen to the bottom, it reverses the order so it starts fromm bottom to top
              reverse: true,
              itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(8),
                  child: MessageBubble(
                    key: ValueKey(chatDocs[index].documentID),
                    isMe: chatDocs[index]['userId'] == snapshot.data.uid,
                    message: chatDocs[index]['text'],
                    username: chatDocs[index]['username'],
                    userImage: chatDocs[index]['userImage'],
                  )),
              itemCount: chatDocs.length,
            );
          },
        );
      },
    );
  }
}
