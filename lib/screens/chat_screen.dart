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
    );
  }
}
