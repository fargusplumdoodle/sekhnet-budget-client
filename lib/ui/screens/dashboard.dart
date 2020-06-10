import 'package:budget/model/budget.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:budget/ui/widgets/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var data = {
  'total': 25000,
  'coast_time': 3,
  'debt': 5,
  'budgets': [
    BudgetModel(1, 'food', 30, 1005, 9),
    BudgetModel(2, 'housing', 10, 12, 9),
    BudgetModel(3, 'medical', 20, 102, 9),
    BudgetModel(5, 'comic books', 3440, 12, 9),
    BudgetModel(8, 'oh yea', 12, 1234569, 9),
    BudgetModel(7, 'transportation', 3440, 12, 9),
    BudgetModel(4, 'savings', 30, 1002, 9),
    BudgetModel(6, 'debt', 12, 1200, 9),
  ]
};

class Dashboard extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Base.appBar(),
      drawer: Base.drawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(8.8),
        child: Column(
          children: <Widget>[
            Card(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: ListTile(
                        title: Text(
                          'Dashboard',
                          style: TextStyle(fontSize: 26),
                        ),
                        subtitle: Text(
                            'Coast time: ${data['coast_time']} months\nDebt: ${data['debt']}\$'))),
                Expanded(
                    child: Text(
                  '${data["total"]}\$',
                  style: TextStyle(fontSize: 46),
                ))
              ],
            )),
            Expanded(child: buildBudgetDashboard(data['budgets']))
          ],
        ),
      ),
    );
  }
}
