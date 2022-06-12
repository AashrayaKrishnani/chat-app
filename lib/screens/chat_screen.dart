import 'package:chat_app/widgets/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const String route = '/chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App 🙊'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/8U8sBMKjwBouQPKiC5sP/messages')
              .snapshots(),
          builder: (ctx, ss) {
            if (ss.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = (ss.data as QuerySnapshot).docs;

            return ListView.builder(
              itemBuilder: (ctx, ind) => Text(docs[ind]['text']),
              itemCount: docs.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("chats/8U8sBMKjwBouQPKiC5sP/messages")
              .add({'text': "This was added via the button :D"});
        },
      ),
      drawer: const MainDrawer(),
    );
  }
}
