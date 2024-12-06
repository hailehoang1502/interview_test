import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/showToast.dart';

void SignUserIn(BuildContext context, String email, String password) async {

  showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim()
    );
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    showToast("Sai email hoặc mật khẩu");
  }
}