import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogInPage extends StatefulWidget {
  void Function()? onTap;
  LogInPage({super.key, required this.onTap});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isChecked = false;
  bool _isForgetPasswordPressed = false;
  bool _isPasswordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void SignUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showToast("Sai email hoặc mật khẩu");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.transparent,
      textColor: Colors.red,
      fontSize: 16.0,
    );
  }

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(left: 20, top: 15, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.5, color: Colors.black)),
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      hintText: "Nhập email",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(left: 20, top: 15, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.5, color: Colors.black)),
                child: TextField(
                  obscureText: !_isPasswordVisible, // Toggle visibility
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10), // Adjust padding,
                    border: InputBorder.none,
                    hintText: "Nhập mật khẩu",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility // Open eye icon
                            : Icons.visibility_off, // Closed eye icon
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle visibility
                        });
                      },
                    ),
                  ),
                ),
              ),

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
                          _isForgetPasswordPressed =
                              true; // Change state on press down
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isForgetPasswordPressed =
                              false; // Reset state on release
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isForgetPasswordPressed =
                              false; // Reset state if cancel
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

              //log in button
              Container(
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue, // Background color
                      side: const BorderSide(
                          color: Colors.blue, width: 2), // Border
                    ),
                    onPressed: SignUserIn, // Action when the button is pressed
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

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
