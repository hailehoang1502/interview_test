import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_interview_test/components/confirm_password_input.dart';
import 'package:flutter_interview_test/components/email_input.dart';
import 'package:flutter_interview_test/components/password_input.dart';
import 'package:flutter_interview_test/components/submit_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../functions/sign_up.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Menu",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      Text(
                        "Thanh toán nhanh chóng \ntại mọi cửa hàng.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),

              //register
              //email
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              EmailInput(emailController: emailController),

              //mật khẩu
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mật khẩu",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              PasswordInput(passwordController: passwordController),

              Container(
                margin: const EdgeInsets.only(top: 20, left: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nhập lại mật khẩu",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              ConfirmPasswordInput(
                  confirmPasswordController: confirmPasswordController),

              //sign up button
              SubmitButton(
                  onPressed: () => SignUserUp(
                      context, emailController.text,
                      passwordController.text, confirmPasswordController.text),
                  label: 'Đăng ký'),

              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Đã có tài khoản? ",
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Đăng nhập ngay",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
