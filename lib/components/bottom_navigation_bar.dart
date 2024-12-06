import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
