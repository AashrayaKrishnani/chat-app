import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
    this.message,
    this.username, {
    Key? key,
  }) : super(key: key);

  final String message;
  final String username;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UsersProvider>(context).username,
        builder: (ctx, ss) {
          if (ss.connectionState == ConnectionState.done && ss.hasData) {
            final bool isMe = username == ss.data.toString();
            final _textAlign = isMe ? TextAlign.right : TextAlign.left;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      child: Text(
                        username,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87.withOpacity(.75),
                            fontWeight: FontWeight.bold),
                        textAlign: _textAlign,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                          bottomLeft: Radius.circular(isMe ? 10 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 10),
                        ),
                        color: isMe
                            ? Colors.grey.shade400
                            : Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.5),
                      ),
                      child: Text(message,
                          style: TextStyle(
                              // fontWeight: !isMe ? FontWeight.bold : null,
                              fontSize: 20,
                              color: isMe
                                  ? Colors.black.withOpacity(.76)
                                  : Theme.of(context).colorScheme.primary),
                          textAlign: _textAlign),
                    ),
                  ],
                ),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.grey.shade300,
                ),
                child: const Text(
                  '...',
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(0),
                  ),
                  color: Colors.grey.shade300,
                ),
                child: const Text('...',
                    style: TextStyle(fontSize: 25, color: Colors.black87),
                    textAlign: TextAlign.right),
              ),
            ],
          );
        });
  }
}
