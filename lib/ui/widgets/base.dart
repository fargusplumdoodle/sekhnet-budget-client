import 'package:budget/ui/screens/add_transaction.dart';
import 'package:flutter/material.dart';

class Base {
  static Widget appBar() => AppBar(
        title: Text('Sekhnet Budget'),
      );

  static Widget drawer() => Drawer(
          child: Center(
        child: ListView(
          children: [
            Text('Dashboard'),
            Text('Transactions'),
            Text('Settings'),
          ],
        ),
      ));

  static Widget floatingActionButton(context) => FloatingActionButton(
      tooltip: 'Add transaction',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, AddTransactionForm.routeName);
      });
}
