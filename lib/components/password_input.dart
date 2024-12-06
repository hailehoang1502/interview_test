import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordInput({super.key, required this.passwordController});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(left: 20, top: 15, right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5, color: Colors.black)),
      child: TextField(
        obscureText: !_isPasswordVisible,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.passwordController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 10),
          border: InputBorder.none,
          hintText: "Nhập mật khẩu",
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible =
                !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
