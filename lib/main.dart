import 'package:bloc/bloc.dart';
import 'package:budget/simple_bloc_observer.dart';
import 'package:budget/ui/screens/add_transaction.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:budget/ui/screens/dashboard.dart';
import 'package:budget/ui/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.routeName,
      routes: {
        Dashboard.routeName: (context) => Dashboard(),
        BudgetDetail.routeName: (context) => BudgetDetail(),
        AddTransactionScreen.routeName: (context) => AddTransactionScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      title: 'Sekhnet Budget',
      theme: ThemeData.dark(),
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}
