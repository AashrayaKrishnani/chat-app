import 'dart:developer';

import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/widgets/error_dialog.dart';
import 'package:chat_app/widgets/snack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

enum FormType {
  login,
  signup,
}

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  Map<String, String> _inputData = {
    'email': '',
    'username': '',
    'password': '',
    'confirmPassword': '',
  };
  var _mode = FormType.login;
  var _isLoading = false;

  Future<void> _submit() async {
    // Make Sure to Put Off The SoftKeyboard ;)
    FocusScope.of(context).unfocus();
    if (!_formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formkey.currentState!.save();

    try {
      var auth = FirebaseAuth.instance;
      var sms = ScaffoldMessenger.of(context);

      if (_mode == FormType.login) {
        // Loggin In
        final authData = await auth.signInWithEmailAndPassword(
            email: _inputData['email']!, password: _inputData['password']!);
        sms.showSnackBar(Snack(
          text: 'Welcome back!',
          textColor: Colors.white,
          bgColor: Colors.green,
        ));

        // Getting username and Storing it.
        final data = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: auth.currentUser!.uid)
            .get();
        await Provider.of<UsersProvider>(context, listen: false)
            .saveUsername(data.docs[0]['username'], auth.currentUser!.uid);
      } else if (_mode == FormType.signup) {
        // Signing up!

        // Checking Validity of Uname.
        final data = await FirebaseFirestore.instance
            .collection("/users")
            .where('username', isEqualTo: _inputData['username'])
            .get();
        if (data.docs.length == 0) {
          // Acceptable Username
          final authData = await auth.createUserWithEmailAndPassword(
              email: _inputData['email']!, password: _inputData['password']!);
          sms.showSnackBar(Snack(
            text: 'Signed Up Successfully as ${_inputData['username']}!',
            textColor: Colors.white,
            bgColor: Colors.green,
          ));
          // Adding UserName and uid to /users/{username}
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_inputData["username"])
              .set({
            'uid': auth.currentUser!.uid,
            'username': _inputData['username']
          });
        } else {
          // Already Used Username
          showDialog(
              context: context,
              builder: (ctx) => ErrorDialog(
                    title: 'Be Creative! ^^',
                    content:
                        'Username Already in Use. I know you can do better than that! ;p',
                    buttonMessage: 'Yes!',
                    bgColor:
                        Theme.of(context).colorScheme.secondary.withOpacity(.7),
                  ));

          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
    } on FirebaseException catch (e) {
      final message = e.message ??
          'Error occured. Please check your details and try again.';

      showDialog(
          context: context,
          builder: (ctx) => ErrorDialog(
                bgColor: Colors.white,
                buttonMessage: 'Alright :)',
                content: message,
                title: 'Oopsies!',
                textColor: Theme.of(context).colorScheme.primary,
              ));
    } catch (e) {
      log(e.toString() + DateTime.now().toString());
      showDialog(
          context: context,
          builder: (ctx) => ErrorDialog(
                bgColor: Colors.white,
                textColor: Theme.of(context).colorScheme.primary,
              ));
    }
    setState(() {
      _isLoading = false;
      _formkey.currentState!.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            enabled: !_isLoading,
            validator: (val) {
              if (val == null || val.toString().trim().isEmpty) {
                return 'Please Enter Email.';
              } else if (!val.toString().contains('@') ||
                  !val.toString().contains('.') ||
                  val.toString().trim().contains(' ')) {
                return 'Pleaes Enter Valid Email';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (val) {
              _inputData['email'] = val.toString().trim();
            },
          ),
          if (_mode == FormType.signup)
            TextFormField(
                enabled: _mode == FormType.signup && !_isLoading,
                decoration: const InputDecoration(labelText: 'UserName'),
                validator: (val) {
                  if (val == null || val.toString().trim().isEmpty) {
                    return 'Please Enter UserName.';
                  } else if (val.toString().contains(' ')) {
                    return 'Pleaes Enter Valid UserName';
                  } else if (val.toString().trim().length > 20) {
                    return 'Short Usernames are Best!';
                  }
                  return null;
                },
                onSaved: (val) {
                  _inputData['username'] = val.toString().trim();
                }),
          TextFormField(
              enabled: !_isLoading,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (val) {
                if (val == null || val.toString().trim().isEmpty) {
                  return 'Please Enter Password.';
                } else if (val.toString().length < 8) {
                  return 'Pleaes Enter Valid Password';
                }
                return null;
              },
              obscureText: true,
              onChanged: (val) {
                _inputData['password'] = val.trim();
              },
              onSaved: (val) {
                _inputData['password'] = val.toString().trim();
              }),
          if (_mode == FormType.signup)
            TextFormField(
                enabled: _mode == FormType.signup && !_isLoading,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (val) {
                  if (val == null || val.toString().trim().isEmpty) {
                    return 'Please Enter Password.';
                  } else if (val.toString().contains(' ')) {
                    return 'Pleaes Enter Valid Password';
                  } else if (_inputData['password'] != val.toString().trim()) {
                    return 'Passwords Do Not Match';
                  }
                  return null;
                },
                obscureText: true,
                onSaved: (val) {
                  _inputData['confirmPassword'] = val.toString().trim();
                }),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(101, 35),
                        ),
                        onPressed: _submit,
                        child:
                            Text(_mode == FormType.login ? 'Login' : 'Sign Up'),
                      ),
                      TextButton(
                        onPressed: () {
                          final mode = _mode == FormType.login
                              ? FormType.signup
                              : FormType.login;
                          setState(() {
                            _mode = mode;
                            _formkey.currentState!.reset();
                          });
                        },
                        child: Text(_mode == FormType.login
                            ? 'Create an Account'
                            : 'I Already Have an Account'),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
