import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/showToast.dart';

void SignUserUp(BuildContext context, String email, String password, String confirmPassword) async {
  showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });

  try {
    if (password == confirmPassword) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } else {
      showToast("Mật khẩu chưa trùng khớp");
    }
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    if (e.code == 'invalid-email') {
      showToast("Email không hợp lệ");
    } else if (e.code == 'email-already-in-use') {
      showToast("Email đã được sử dụng");
    } else if (e.code == 'weak-password') {
      showToast("Mật khẩu phải dài ít nhất 6 ký tự");
    } else {
      showToast("Đăng ký thất bại: ${e.message}");
    }
  }
}