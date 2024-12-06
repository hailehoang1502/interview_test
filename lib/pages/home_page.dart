import 'package:flutter/material.dart';
import 'package:flutter_interview_test/components/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/slideable_grid.dart';
import '../functions/format_currency.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  var revenue = 0;

  @override
  void initState() {
    super.initState();
    _loadRevenue();
  }

  Future<void> _loadRevenue() async {
    final prefs = await SharedPreferences.getInstance();
    final storedRevenue = prefs.getInt('revenue') ?? 0;
    final lastDate = prefs.getString('last_date') ?? '';
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);

    // Reset revenue if the date has changed
    if (lastDate != currentDate) {
      revenue = 0; // Reset to zero
      prefs.setString('last_date', currentDate); // Update stored date
    } else {
      revenue = storedRevenue; // Load saved revenue
    }

    setState(() {}); // Update the UI with loaded revenue
  }

  Future<void> _saveRevenue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('revenue', revenue);
  }

  Future<void> _recordRevenue() async {
    final prefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);
    final storedRevenue = revenue.toString();

    List<String> dates = prefs.getStringList('dates') ?? [];
    List<String> revenues = prefs.getStringList('revenues') ?? [];

    // Check if today’s revenue already exists, update it or add new entry
    if (!dates.contains(currentDate)) {
      dates.add(currentDate);
      revenues.add(storedRevenue);
    } else {
      final index = dates.indexOf(currentDate);
      revenues[index] = storedRevenue;
    }

    // Save the updated lists to SharedPreferences
    await prefs.setStringList('dates', dates);
    await prefs.setStringList('revenues', revenues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        // app bar
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            // const IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
          ],
        ),
        drawer: const AppDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
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
                          const Row(
                            children: [
                              Text("Doanh thu hôm nay"),
                            ],
                          ),
                          Row(
                            children: [
                              Text("${formatCurrency(revenue)}đ",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purpleAccent)),
                              const SizedBox(width: 5),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    color: const Color(0xDFE8E8E7),
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                // Higher fuction
                // void sum (int a, int b, Fuction testdsafs)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SlideableGrid(
                     income: revenue,
                     callback: (newValue) {
                       print("<New value> $newValue");
                       setState(() {
                       revenue = newValue;
                       _saveRevenue();
                       _recordRevenue();
                       });
                     },
                  ),
                ),
              ],
            ),
          ),
        ),

        // bottom navigation bar
        // bottomNavigationBar: const BottomBar()
    );
  }
}
