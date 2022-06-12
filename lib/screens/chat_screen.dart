import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App 🙊'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, ind) => Text('yay!! '),
        itemCount: 10,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/8U8sBMKjwBouQPKiC5sP/messages')
              .snapshots()
              .listen(
            (data) {
              data.docs.forEach(
                (e) {
                  print(e['text']);
                },
              );
            },
          );
        },
      ),
    );
  }
}
