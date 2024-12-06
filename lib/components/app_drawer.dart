import 'package:flutter/material.dart';
import 'package:flutter_interview_test/functions/sign_out.dart';
import 'package:flutter_interview_test/pages/revenue_history_page.dart';
import 'drawer_list_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
              child: Center(
                child: Icon(
                    Icons.fastfood,
                    size: 72,
                    color: Theme.of(context).colorScheme.inversePrimary),
              )
          ),
          DrawerListTile(
              text: "Màn hình chính",
              icon: Icons.home,
              onTap: () => Navigator.pushNamed(context, '/home_page')
          ),
          DrawerListTile(text: "Thông tin", icon: Icons.person, onTap: ()=>{}),
          DrawerListTile(
              text: "Doanh Thu",
              icon: Icons.monetization_on,
              onTap: () => Navigator.pushNamed(context, '/revenue_history_page')
          ),
          const DrawerListTile(
              text: "Đăng xuất",
              icon: Icons.logout,
              onTap: signUserOut
          ),
        ],
      ),
    );
  }
}