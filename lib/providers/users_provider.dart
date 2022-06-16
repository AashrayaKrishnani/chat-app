import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/db.dart';

class UsersProvider with ChangeNotifier {
  var _username = '';
  List<Map<String, String>> _usersData = [];

  Future<void> saveUsername(String username, String uid) async {
    if (!_usersData.any((m) => m['uid'] == uid)) {
      // Adding To Local Cache List as well.
      _usersData.add({'uid': uid, 'userName': username});
      if (uid == FirebaseAuth.instance.currentUser!.uid) {
        _username = username;
      }
      notifyListeners();
    }
    DB.insert(DB.usersTable, {'uid': uid, 'username': username});
  }

  Future<void> logout() async {
    _username = '';
    await FirebaseAuth.instance.signOut();
  }

  Future<String> get username async {
    if (_username != '') {
      return _username;
    }

    final _usersData = await DB.getData(DB.usersTable);
    final _uid = await FirebaseAuth.instance.currentUser!.uid;

    for (var m in _usersData) {
      if (m['uid'] == _uid) {
        _username = m['username'];
        break;
      }
    }

    if (_username != '') {
      return _username;
    }

    // Reaching out to Firebase to get Username!
    // TODO
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _uid)
        .get();

    _username = data.docs[0]['username'];

    if (_username != '') {
      return _username;
    }

    return '';
  }
}
