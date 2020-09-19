import 'package:bloc/bloc.dart';
import 'package:budget/repositories/account.dart';
import 'package:budget/simple_bloc_observer.dart';
import 'package:budget/ui/screens/add_transaction.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:budget/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  login().then((success) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Dashboard.routeName,
      routes: {
        Dashboard.routeName: (context) => Dashboard(),
        BudgetDetail.routeName: (context) => BudgetDetail(),
        AddTransactionScreen.routeName: (context) => AddTransactionScreen(),
      },
      title: 'Sekhnet Budget',
      theme: ThemeData.dark(),
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}
