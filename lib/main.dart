import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_interview_test/pages/auth/auth_page.dart';
import 'package:flutter_interview_test/pages/auth/log_in_page.dart';
import 'package:flutter_interview_test/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_interview_test/pages/revenue_history_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const AuthPage(),
      routes: {
        '/home_page':(context) => const HomePage(),

        '/revenue_history_page':(context) => const RevenueHistoryPage(),
      },
    );
  }

}
