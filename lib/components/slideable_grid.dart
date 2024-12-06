import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../functions/format_currency.dart';
import '../helper/showToast.dart';
import '../models/GridItem.dart';
import 'package:flutter_interview_test/components/add_button.dart';
import '../models/GridItemData.dart';
import 'dart:convert';

class SlideableGrid extends StatefulWidget {
  int income;
  Function callback;

  SlideableGrid({super.key, required this.income, required this.callback});

  @override
  _SlideableGridState createState() => _SlideableGridState();
}

class _SlideableGridState extends State<SlideableGrid> {
  final PageController _pageController = PageController();
  late List<GridItemData> items;

  @override
  void initState() {
    super.initState();
    items = List.generate(
      23,
      (index) => GridItemData(
        id: index + 1,
        state: 'Bàn trống',
        price: null,
        time: null,
      ),
    );
    _loadGridState();
  }

  Future<void> _loadGridState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? gridStateString = prefs.getString('grid_state');
    final String? lastSavedDate = prefs.getString('grid_state_date');

    final DateTime now = DateTime.now();
    if (lastSavedDate != null) {
      final DateTime savedDate = DateTime.parse(lastSavedDate);
      if (now.day != savedDate.day ||
          now.month != savedDate.month ||
          now.year != savedDate.year) {
        // Reset grid state for a new day
        items = List.generate(
          23,
          (index) => GridItemData(
            id: index + 1,
            state: 'Bàn trống',
            price: null,
            time: null,
          ),
        );
      } else if (gridStateString != null) {
        // Load grid state from saved data
        List<dynamic> gridState = jsonDecode(gridStateString);
        for (var state in gridState) {
          int id = state['id'];
          String itemState = state['state'];
          int? price = state['price'];
          items[id - 1] = GridItemData(
            id: id,
            state: itemState,
            price: price,
            time: state['time'] != null ? DateTime.parse(state['time']) : null,
          );
        }
      }
    }
  }

  Future<void> _saveGridState() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> gridState = items.map((item) {
      return {
        'id': item.id,
        'state': item.state,
        'price': item.price,
        'time': item.time?.toIso8601String(),
      };
    }).toList();

    await prefs.setString('grid_state', jsonEncode(gridState));
    await prefs.setString('grid_state_date', DateTime.now().toIso8601String());
  }

  // add new order
  void _addNewOrder() {
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
                final int? id = int.tryParse(idController.text.trim());
                final String price = priceController.text.trim();

                if (id == null) {
                  showToast("Xin vui lòng điền số bàn");
                } else if (id > 23 || id == 0) {
                  showToast("Không thể thêm, bàn không tồn tại");
                } else {
                  final existingItemIndex =
                      items.indexWhere((item) => item.id == id);
                  if (existingItemIndex != -1) {
                    if (items[existingItemIndex].state != 'Bàn trống') {
                      showToast("Không thể thêm, bàn đã có người ngồi");
                    } else if (price.isEmpty) {
                      showToast("Xin vui lòng điền đơn giá");
                    } else {
                      setState(() {
                        items[existingItemIndex] = GridItemData(
                            id: id,
                            state: "Chờ món",
                            price: int.tryParse(price),
                            time: DateTime.now());
                      });
                      _saveGridState();
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

  void _confirmPayment(GridItemData item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Thanh toán"),
            content: Text(
                "Xác nhận thanh toán bàn số: ${item.id}\nĐơn giá: ${formatCurrency(item.price)}đ"),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.income += item.price!;
                      item.state = "Bàn trống";
                      item.price = null;

                      // Function -> nhận param là cái revenue mới --> truyền cho về cho home
                      widget.callback(widget.income);
                    });
                    _saveGridState();
                    showToast("Thanh toán thành công");
                    Navigator.pop(context);
                  },
                  child: Text("Thanh toán")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Hủy"))
            ],
          );
        });
  }

  void _confirmOrder(GridItemData item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Đủ món'),
            content: Text(
                'Xác nhận đủ món bàn số: ${item.id}\nĐơn giá: ${formatCurrency(item.price)}đ'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    item.state = "Đủ món";
                  });
                  _saveGridState();
                  Navigator.pop(context);
                },
                child: const Text('Xác nhận'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Hủy'),
              ),
            ],
          );
        });
  }

  // edit price
  void _pendingOrder(GridItemData item) {
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Đơn giá bàn số ${item.id}'),
          content: TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Đơn giá'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String price = priceController.text.trim();
                if (price.isEmpty) {
                  showToast("Xin vui lòng điền đơn giá");
                } else {
                  setState(() {
                    item.price = int.tryParse(price);
                    item.state = "Chờ món";
                  });
                  _saveGridState();
                  showToast("Thêm thành công");
                  Navigator.pop(context);
                }
              },
              child: const Text('Lưu'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  item.state = "Bàn trống";
                });
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const int itemsPerPage = 9;
    final int pageCount = (items.length / itemsPerPage).ceil();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            itemBuilder: (context, pageIndex) {
              final int startIndex = pageIndex * itemsPerPage;
              final int endIndex = (startIndex + itemsPerPage < items.length)
                  ? startIndex + itemsPerPage
                  : items.length;

              final List<GridItemData> pageItems = items
                  .sublist(startIndex, endIndex)
                  .toList()
                ..addAll(List<GridItemData>.filled(
                    itemsPerPage - (endIndex - startIndex),
                    GridItemData(
                        id: 0, state: 'Bàn trống', price: null, time: null)));

              return Center(
                child: SizedBox(
                  width: 300,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      final item = pageItems[index];
                      return item.id != 0
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (item.state == "Bàn trống") {
                                    item.state = "Gọi món";
                                    item.time = DateTime.now();
                                  } else if (item.state == "Gọi món") {
                                    _pendingOrder(item);
                                  } else if (item.state == "Chờ món") {
                                    _confirmOrder(item);
                                  } else {
                                    _confirmPayment(item);
                                  }
                                });
                              },
                              child: GridItem(data: item),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              );
            },
          ),
        ),

        // space
        const SizedBox(height: 16),

        // dot
        SmoothPageIndicator(
          controller: _pageController,
          count: pageCount,
          effect: const WormEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
          ),
        ),

        //space
        const SizedBox(height: 16),

        // add new order button
        AddButton(onPressed: _addNewOrder),
        const SizedBox(height: 20),

        // list of orders
        Column(
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bàn ${item.id}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                  if (item.state != "Bàn trống" && item.time != null)
                    Text(item.time != null ? '${item.time!.hour} : ${item.time!.minute.toString().padLeft(2, '0')}'
                          : '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  Text(
                    item.state,
                    style: TextStyle(
                        fontSize: 16,
                        color: item.state == 'Bàn trống'
                            ? Colors.yellow.shade700
                            : item.state == 'Gọi món'
                                ? Colors.red
                                : item.state == 'Chờ món'
                                    ? Colors.orange
                                    : Colors.green)
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
