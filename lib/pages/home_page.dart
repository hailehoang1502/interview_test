import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Phở Quỳnh Anh",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Doanh thu hôm nay"),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                      Row(
                        children: [
                          Text("12.560.000đ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purpleAccent)),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_upward,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
                color: Color(0xDFE8E8E7),
                child: const SizedBox(
                  height: 20,
                  width: double.infinity,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Danh sách bàn",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Tất cả khu vực",
                      style: TextStyle(fontSize: 16, color: Colors.blue))
                ],
              ),
            ),
            Expanded(child: SlideableGrid()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0),
              child: const Icon(Icons.stacked_bar_chart_sharp),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class SlideableGrid extends StatefulWidget {
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
        price: '',
      ),
    );
  }

  void _showAddItemDialog() {
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

                if (id == null || id > 23) {
                  showFailedToast("Không thể thêm, bàn không tồn tại");
                } else {
                  final existingItemIndex =
                      items.indexWhere((item) => item.id == id);

                  if (existingItemIndex != -1) {
                    if (items[existingItemIndex].state == 'Đủ món') {
                      showFailedToast("Không thể thêm, bàn đã có người ngồi");
                    } else {
                      setState(() {
                        items[existingItemIndex] =
                            GridItemData(id: id, state: 'Đủ món', price: price);
                      });
                      showSuccesToast("Thêm thành công");
                    }
                  } else {
                    setState(() {
                      items.add(
                          GridItemData(id: id, state: 'Đủ món', price: price));
                    });
                    showSuccesToast("Thêm thành công");
                  }
                }

                Navigator.pop(context);
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

  void _showEditWordDialog(GridItemData item) {
    final TextEditingController priceController =
        TextEditingController(text: item.price);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đơn giá'),
          content: TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Đơn giá'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  item.price = priceController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
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

  @override
  Widget build(BuildContext context) {
    final int itemsPerPage = 9;
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
                        id: 0, state: 'Bàn trống', price: '')));

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
                                  if (item.state == "Đủ món") {
                                    item.state = "Bàn trống";
                                    item.price = '';
                                  } else {
                                    _showEditWordDialog(item);
                                    item.state = "Đủ món";
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
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _showAddItemDialog,
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
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void showFailedToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showSuccesToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class GridItemData {
  final int id;
  String state;
  String price;

  GridItemData({required this.id, required this.state, required this.price});
}

class GridItem extends StatelessWidget {
  final GridItemData data;
  const GridItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: data.state == 'Đủ món' ? Colors.red : Colors.blue,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${data.id}',
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            data.state,
            style: TextStyle(
              color: data.state == 'Đủ món' ? Colors.red : Colors.green,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.price.isNotEmpty ? '${data.price}đ' : '',
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
