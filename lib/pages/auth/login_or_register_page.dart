import 'package:flutter/material.dart';
import 'package:flutter_interview_test/pages/auth/log_in_page.dart';
import 'package:flutter_interview_test/pages/auth/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogInPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
