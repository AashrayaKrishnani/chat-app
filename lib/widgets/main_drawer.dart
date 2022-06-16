import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'snack.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: (() {
                final sms = ScaffoldMessenger.of(context);
                FirebaseAuth.instance.signOut();
                sms.showSnackBar(Snack(
                  text: 'Logged Out.',
                  bgColor: Colors.red,
                  textColor: Colors.white,
                ));
              }),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  'LogOut',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
