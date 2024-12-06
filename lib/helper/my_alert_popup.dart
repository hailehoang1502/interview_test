import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_test/helper/showToast.dart';
import '../models/GridItemData.dart';

class MyAlertPopUp {
  static void showAddItemDialog(
      {required BuildContext context,
      required List<GridItemData> items,
      required Function callback}) {

    final TextEditingController idController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm đơn mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'Bàn số'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Đơn giá'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final int? id = int.tryParse(idController.text);
                final String price = priceController.text;

                if (id == null) {
                  showToast("Xin vui lòng điền số bàn");
                } else if (id > 23 || id == 0) {
                  showToast("Không thể thêm, bàn không tồn tại");
                } else {
                  final existingItemIndex =
                      items.indexWhere((item) => item.id == id);
                  if (existingItemIndex != -1) {
                    if (items[existingItemIndex].state == 'Đủ món') {
                      showToast("Không thể thêm, bàn đã có người ngồi");
                    } else if (price.isEmpty) {
                      showToast("Xin vui lòng điền đơn giá");
                    } else {
                      callback;
                      // setState(() {
                      //   items[existingItemIndex] = GridItemData(
                      //       id: id,
                      //       state: "Đủ món",
                      //       price: int.tryParse(price));
                      // });
                      showToast("Thêm thành công");
                      Navigator.pop(context);
                    }
                  }
                }
              },
              child: const Text('Thêm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }
}
