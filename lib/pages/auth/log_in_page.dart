import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_interview_test/components/email_input.dart';
import 'package:flutter_interview_test/components/password_input.dart';
import 'package:flutter_interview_test/components/submit_button.dart';
import '../../functions/sign_in.dart';

class LogInPage extends StatefulWidget {
  void Function()? onTap;
  LogInPage({super.key, required this.onTap});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isChecked = false;
  bool _isForgetPasswordPressed = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

              //log in
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
                margin: EdgeInsets.only(top: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 10),
                          width: 19, // Width of the checkbox
                          height: 19, // Height of the checkbox
                          decoration: BoxDecoration(
                              color: _isChecked
                                  ? Colors.transparent
                                  : Colors.white, // Background color
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 2, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(4)), // Rounded corners
                          child: Checkbox(
                            value: _isChecked,
                            checkColor: Colors.blue,
                            activeColor: Colors.transparent,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                        ),
                        const Text(
                          "Lưu mật khẩu",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isForgetPasswordPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isForgetPasswordPressed = false;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isForgetPasswordPressed = false;
                        });
                      },
                      child: Opacity(
                        opacity: _isForgetPasswordPressed ? 0.5 : 1.0,
                        child: const Text(
                          "Quên mật khẩu?",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //sign in button
              SubmitButton(
                  onPressed: () => SignUserIn(
                      context, emailController.text, passwordController.text),
                  label: "Đăng nhập"),

              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Chưa có tài khoản? ",
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Đăng ký ngay",
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
