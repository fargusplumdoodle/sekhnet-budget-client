import 'package:bloc/bloc.dart';
import 'package:budget/simple_bloc_observer.dart';
import 'package:budget/ui/ui.dart';
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
        ListTransactions.routeName: (context) => ListTransactions(),
        EditTransaction.routeName: (context) => EditTransaction(),
      },
      title: 'Sekhnet Budget',
      theme: ThemeData.dark(),
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}
