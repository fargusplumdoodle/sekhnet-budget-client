import 'package:budget/model/budget.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:flutter/material.dart';

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
                      style: TextStyle(fontSize: 20)),
                ),
                Text('${budgets[index].balance}\$',
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      });
}
