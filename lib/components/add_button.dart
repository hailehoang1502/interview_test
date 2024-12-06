import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final void Function()? onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        minimumSize: const Size(60, 60),
        elevation: 10,
      ),
      child: const Icon(
        Icons.add,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
