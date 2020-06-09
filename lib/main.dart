import 'package:budget/ui/screens/budget_detail.dart';
import 'package:budget/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Dashboard.routeName,
      routes: {
        Dashboard.routeName: (context) => Dashboard(),
        BudgetDetail.routeName: (context) => BudgetDetail(),
      },
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      darkTheme:
          ThemeData(primaryColor: Colors.blue, brightness: Brightness.light),
    );
  }
}
