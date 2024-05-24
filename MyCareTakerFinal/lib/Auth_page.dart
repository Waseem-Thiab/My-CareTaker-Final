import 'package:fireproject/Main_pages/Screens/login_screen.dart';
import 'package:fireproject/Main_pages/Screens/signup_screen.dart';
import 'package:flutter/widgets.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
    showLoginPage = !showLoginPage;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(showSignUpPage: toggleScreens);
    } else {
      return SignUpScreen(showLoginPage: toggleScreens);
    }
  }
}
