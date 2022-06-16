import 'dart:math';

import 'package:chat_app/widgets/main_drawer.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:chat_app/widgets/message_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CommonChatScreen extends StatelessWidget {
  static const String route = '/chat';

  const CommonChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Chat 🙊'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/common-chat')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (ctx, ss) {
                    if (ss.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    QuerySnapshot data = ss.data as QuerySnapshot;
                    final docs = data.docs;
                    return ListView.builder(
                      itemCount: min(10, docs.length),
                      itemBuilder: ((context, index) => Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: MessageBubble(
                                docs[index]['text'], docs[index]['username']),
                          )),
                    );
                  }),
            ),
            MessageField(),
          ],
        ),
      ),
      drawer: const MainDrawer(),
    );
  }
}
