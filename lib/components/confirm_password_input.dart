import 'package:flutter/material.dart';

class ConfirmPasswordInput extends StatefulWidget {
  final TextEditingController confirmPasswordController;
  const ConfirmPasswordInput({super.key, required this.confirmPasswordController});

  @override
  State<ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {
  bool _isConfirmPasswordVisible = false;

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
        obscureText: !_isConfirmPasswordVisible,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.confirmPasswordController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 10),
          border: InputBorder.none,
          hintText: "Nhập lại mật khẩu",
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible =
                !_isConfirmPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
