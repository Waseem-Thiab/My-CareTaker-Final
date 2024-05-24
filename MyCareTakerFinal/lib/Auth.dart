import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/Auth_page.dart';
import 'package:fireproject/Main_pages/Screens/Nav%20bar.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const NavigationExample();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
