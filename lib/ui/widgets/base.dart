import 'package:budget/repositories/repositories.dart';
import 'package:budget/ui/screens/add_transaction.dart';
import 'package:budget/ui/screens/dashboard.dart';
import 'package:budget/ui/screens/list_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../ui.dart';

class Base {
  static Widget appBar(String title) => AppBar(
        title: Text(title),
      );

  static Widget drawer(BuildContext context) => Drawer(
          child: Center(
        child: ListView(
          children: [
            FlatButton(
              child: Text("DASHBOARD"),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, Dashboard.routeName);
                });
              },
            ),
            FlatButton(
              child: Text("TRANSACTIONS"),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                      context, ListTransactions.routeName);
                });
              },
            ),
            FlatButton(
              child: Text("TRANSFER FUNDS"),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                      context, TransferFunds.routeName);
                });
              },
            ),
            FlatButton(
              child: Text(
                "LOG OUT",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                logout(context);
              },
            )
          ],
        ),
      ));

  static Widget floatingActionButton(context) => FloatingActionButton(
      tooltip: 'Add transaction',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, AddTransactionScreen.routeName);
      });
}
