import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/common_chat_screen.dart';

void main() async {
  // Ensures that Firebase is connected before we start the App :D
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UsersProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.pink,
            secondary: Colors.pinkAccent,
            tertiary: Colors.purpleAccent,
          ),
          textTheme: const TextTheme(
              headline6: TextStyle(color: Colors.white, fontSize: 20)),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, ss) {
            if (ss.hasData) {
              return const CommonChatScreen();
            }
            return const AuthScreen();
          },
        ),
        routes: {
          CommonChatScreen.route: (context) => const CommonChatScreen(),
          AuthScreen.route: (context) => const AuthScreen(),
        },
      ),
    );
  }
}
