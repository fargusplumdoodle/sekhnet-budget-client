import 'package:budget/model/budget.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:budget/ui/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BudgetDetail extends StatelessWidget {
  static const routeName = 'budget_detail';
  static const double h1 = 55;
  static const double h2 = 40;
  @override
  Widget build(BuildContext context) {
    final BudgetModel budget = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: Base.appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  budget.name,
                  style: TextStyle(fontSize: h1),
                ),
              ),
            ),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${budget.percentage}%',
                        style: TextStyle(fontSize: h2),
                      )),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${budget.balance}\$',
                      style: TextStyle(fontSize: h2),
                    ),
                  )
                ],
              ),
            )),
            Divider(),
            Expanded(child: TransactionList(budget, 10, false))
          ],
        ),
      ),
    );
  }
}
