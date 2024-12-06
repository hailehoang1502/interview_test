import 'package:flutter/material.dart';
import 'package:flutter_interview_test/components/app_drawer.dart';
import 'package:flutter_interview_test/functions/format_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../functions/format_currency.dart';

class RevenueHistoryPage extends StatefulWidget {
  const RevenueHistoryPage({super.key});

  @override
  State<RevenueHistoryPage> createState() => _RevenueHistoryPageState();
}

class _RevenueHistoryPageState extends State<RevenueHistoryPage> {
  List<Map<String, dynamic>> revenueData = [];

  @override
  void initState() {
    super.initState();
    _loadRevenueData();
  }

  Future<void> _loadRevenueData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dates = prefs.getStringList('dates') ?? [];
    List<String> revenues = prefs.getStringList('revenues') ?? [];

    List<Map<String, dynamic>> loadedData = [];
    for (int i = 0; i < dates.length; i++) {
      loadedData.add({
        'date': dates[i],
        'revenue': revenues[i],
      });
    }

    setState(() {
      revenueData = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "LỊCH SỬ DOANH THU",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: revenueData.length,
                itemBuilder: (context, index) {
                  final data = revenueData[index];
                  int revenue = int.tryParse(data['revenue']) ?? 0;
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reverseDateFormat(data['date']),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${formatCurrency(revenue)}đ',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
