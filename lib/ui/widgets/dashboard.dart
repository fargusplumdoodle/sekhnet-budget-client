import 'package:budget/globals.dart';
import 'package:budget/model/budget.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:budget/ui/ui.dart';
import 'package:flutter/material.dart';

class BudgetOverview extends StatelessWidget {
  final List<BudgetModel> budgets;

  BudgetOverview(this.budgets);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BudgetStatusCard(budgets),
        Expanded(
          child: PageView(
            scrollDirection: Axis.horizontal,
            children: [
              BudgetList(budgets),
              GlobalReportView(budgets),
            ],
          ),
        ),
      ],
    );
  }
}

Widget BudgetList(List<BudgetModel> budgets) {
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
                Text('${budgets[index].getPrettyBalance(true)}\$',
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      });
}

Widget BudgetStatusCard(List<BudgetModel> budgets) {
  double debt = 0;
  double total = 0;

  // Calculating status info from budgets
  budgets.forEach((element) {
    total += convertToDollars(element.balance);

    if (element.balance < 0) {
      debt += convertToDollars(element.balance);
    }
  });

  String totalPretty = total.round().toString().replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  int coastTime = (total / burnRate).round();

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
              subtitle: Text(
                'Coast time: $coastTime months\nDebt: ${debt.round()}\$',
                style: TextStyle(fontSize: 10),
              ))),
      Expanded(
          child: Text(
        '${totalPretty}\$',
        style: TextStyle(fontSize: 42),
      ))
    ],
  ));
}
