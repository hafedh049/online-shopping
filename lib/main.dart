import 'package:blue_diamond/auth/signin.dart';
import 'package:blue_diamond/exception.dart';
import 'package:blue_diamond/mainer/initializer.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  Main({super.key});
  final Future<FirebaseApp> firebaseApp = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAvwfl062blI0q3VmTUblUlvDZk-V7YnxU",
      appId: "1:101622696642:web:ad8c0a99dbbcb5c01cc95b",
      messagingSenderId: "101622696642",
      projectId: "blue-diamond-4f15b",
      authDomain: "blue-diamond-4f15b.firebaseapp.com",
      storageBucket: "blue-diamond-4f15b.appspot.com",
      measurementId: "G-G9B1JH6ZW7",
    ),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseApp,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SignIn();
                } else {
                  return const Init();
                }
              },
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Center(
              child: CircularProgressIndicator(
                color: tulip,
              ),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FlutterException(exception: snapshot.error.toString()),
          );
        }
      },
    );
  }
}
