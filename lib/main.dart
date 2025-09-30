import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'data/expenses_data.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  // initialize hive

  await Hive.initFlutter();

  //open a hive box
  await Hive.openBox('expense_database');

  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpensesData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
