import 'package:budget/model/budget.dart';
import 'package:flutter/material.dart';

var data = {
  'total': 2500,
  'coast_time': 3,
  'debt': 5,
  'budgets': [
    BudgetModel(1, 'food', 30, 15, 9),
    BudgetModel(2, 'housing', 300, 12, 9),
    BudgetModel(3, 'medical', 440, 12, 9),
    BudgetModel(4, 'savings', 3240, 12, 9),
    BudgetModel(5, 'comic books', 3440, 12, 9),
    BudgetModel(6, 'debt', 1240, 12, 9),
  ]
};

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sekhnet Budget'),
      ),
      drawer: Drawer(
        child: Center(child: Text('in da drawer')),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Card(
                child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: ListTile(
                          title: Text(
                            'Dashboard',
                            style: TextStyle(fontSize: 30),
                          ),
                          subtitle: Text(
                              'Coast time: ${data['coast_time']} months\nDebt: ${data['debt']}\$'))),
                  Expanded(
                      child: Text(
                    '${data["total"]}\$',
                    style: TextStyle(fontSize: 54),
                  ))
                ],
              ),
            )),
            buildBudgetDashboard(data['budgets'])
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
          return Card(
            child: Center(
                child: Text(
                    '${budgets[index].name}\n${budgets[index].balance}\$')),
          );
        });
  }
}
