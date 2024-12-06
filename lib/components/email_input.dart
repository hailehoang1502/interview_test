import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final TextEditingController emailController;
  const EmailInput({super.key, required this.emailController});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
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
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.emailController,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            border: InputBorder.none,
            hintText: "Nhập email",
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
