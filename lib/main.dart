import 'package:bloc/bloc.dart';
import 'package:budget/repositories/login.dart';
import 'package:budget/simple_bloc_observer.dart';
import 'package:budget/ui/screens/add_transaction.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:budget/ui/screens/dashboard.dart';
import 'package:budget/ui/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  String initialRoute = LoginScreen.routeName;
  initLogin()
      .then((showLogin) => {
            if (!showLogin) {initialRoute = Dashboard.routeName}
          })
      .then((value) => runApp(MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key key, this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
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
