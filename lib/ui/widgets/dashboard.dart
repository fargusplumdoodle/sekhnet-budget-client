import 'package:budget/model/budget.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:flutter/material.dart';

Widget BudgetDashboardWidget(List<BudgetModel> budgets) {
  return Expanded(
    child: GridView.builder(
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
                        style: TextStyle(fontSize: 20)),
                  ),
                  Text('${budgets[index].balance}\$',
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          );
        }),
  );
}

Widget StatusCard(List<BudgetModel> budgets) {
  int debt = 0;
  int total = 0;

  // Calculating status info from budgets
  budgets.forEach((element) {
    total += element.balance;

    if (element.balance < 0) {
      debt += element.balance;
    }
  });

  int coastTime = (total / 1800).round(); // todo calculate off of real data

  return Card(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Expanded(
          child: ListTile(
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 26),
              ),
              subtitle: Text('Coast time: $coastTime months\nDebt: $debt\$'))),
      Expanded(
          child: Text(
        '$total\$',
        style: TextStyle(fontSize: 46),
      ))
    ],
  ));
}
