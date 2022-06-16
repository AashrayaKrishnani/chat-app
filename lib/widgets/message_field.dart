import 'package:chat_app/providers/users_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageField extends StatefulWidget {
  MessageField({Key? key}) : super(key: key);

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final _formKey = GlobalKey<FormState>();
  var _isSending = false;
  var _message = '';

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      // TODO
      setState(() {
        _isSending = true;
      });

      _formKey.currentState!.save();
      final username =
          await Provider.of<UsersProvider>(context, listen: false).username;

      await FirebaseFirestore.instance.collection("common-chat/").add({
        'username': username,
        'text': _message,
        'timestamp': Timestamp.now()
      });
      setState(() {
        _isSending = false;
        _formKey.currentState!.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Type all you want!'),
              validator: (val) {
                if (val == null || val.toString().trim().isEmpty) {
                  return 'Can\'t Fool Me ;p Type!!';
                } else if (val.toString().length > 200) {
                  return "Too long! Split Please ><";
                }
              },
              onSaved: (val) {
                _message = val.toString().trim();
              },
              onFieldSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            onPressed: _isSending ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
