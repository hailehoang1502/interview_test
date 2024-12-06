import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  const SubmitButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.blue,
            side: const BorderSide(
                color: Colors.blue, width: 2),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
