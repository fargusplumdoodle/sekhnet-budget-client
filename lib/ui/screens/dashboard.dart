import 'package:budget/model/budget.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:budget/ui/widgets/base.dart';
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
    BudgetModel(4, 'savings', 30, 1002, 9),
    BudgetModel(5, 'comic books', 3440, 12, 9),
    BudgetModel(6, 'debt', 12, 1200, 9),
    BudgetModel(7, 'transportation', 3440, 12, 9),
    BudgetModel(8, 'eyy', 12, 1200, 9),
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

  Widget buildBudgetDashboard(List<BudgetModel> budgets) {
    return GridView.builder(
        itemCount: budgets.length,
        shrinkWrap: true,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, BudgetDetail.routeName,
                  arguments: budgets[index])
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('${budgets[index].name}',
                        style: TextStyle(fontSize: 30)),
                  ),
                  Text('${budgets[index].balance}\$',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          );
        });
  }
}
