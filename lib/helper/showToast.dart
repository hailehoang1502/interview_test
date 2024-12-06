import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: msg.contains("thành công") ? Colors.green : Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
