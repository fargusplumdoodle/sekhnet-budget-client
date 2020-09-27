import 'package:budget/globals.dart';
import 'package:budget/model/budget.dart';
import 'package:budget/ui/screens/budget_detail.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
              BudgetPie(budgets),
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

class BudgetPie extends StatelessWidget {
  final List<BudgetModel> budgets;
  var maxBudget;

  BudgetPie(this.budgets);

  @override
  Widget build(BuildContext context) {
    maxBudget = getMaxBudget();
    return charts.PieChart(_generatePieData(),
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside)
        ]));
  }

  BudgetModel getMaxBudget() {
    var maxBudget = budgets[0];
    for (var i = 0; i < budgets.length; i++) {
      if (budgets[i].balance > maxBudget.balance) {
        maxBudget = budgets[i];
      }
    }
    return maxBudget;
  }

  List<charts.Series<BudgetModel, String>> _generatePieData() {
    return [
      new charts.Series(
        id: 'Budget Balance Distribution',
        data: this.budgets,
        domainFn: (BudgetModel budget, _) => budget.name,
        measureFn: (BudgetModel budget, _) => budget.balance,
        labelAccessorFn: (BudgetModel budget, _) => "${budget.name}",
        colorFn: (BudgetModel budget, __) => getColor(budget),
      ),
    ];
  }

  charts.Color getColor(BudgetModel budget) {
    return charts.MaterialPalette.teal.shadeDefault;
    // TODO: dynamic colors
    if (budget.name == maxBudget.name) {
      return charts.MaterialPalette.teal.shadeDefault;
    }
    var shades = charts.MaterialPalette.teal.makeShades(100);
    var index = 100 -
        ((budget.balance.toDouble() / maxBudget.balance.toDouble()) * 100)
            .round();
    return shades[index];
  }
}
