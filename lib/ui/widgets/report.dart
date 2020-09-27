import 'package:budget/blocs/blocs.dart';
import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalReportView extends StatelessWidget {
  final List<BudgetModel> budgets;

  GlobalReportView(this.budgets);

  /*
  Always gets the last 6 months of data on all budgets
   */
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TransactionBloc(),
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          if (state is TransactionInitial) {
            var query = TransactionDateQuery();
            final now = DateTime.now();
            query.end = DateTime(now.year, now.month, 0);
            query.start = DateTime(now.year, now.month - 6, 0);
            BlocProvider.of<TransactionBloc>(context)
                .add(TransactionDateQueryRequested(data: query));
            return Center(child: CircularProgressIndicator());
          }

          if (state is TransactionLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is TransactionLoadSuccess) {
            return _reportViewWidget(this.budgets, state.transactions);
          } else {
            return Center(
                child: Text(
              "Unable to fetch report data",
            ));
          }
        }));
  }
}

class _reportViewWidget extends StatelessWidget {
  final List<BudgetModel> budgets;
  final List<TransactionModel> transactions;
  Map dataByMonth;

  _reportViewWidget(this.budgets, this.transactions);

  @override
  Widget build(BuildContext context) {
    aggregateDataByMonth();
    return ListView(
      children: [
        Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: BudgetPie(budgets)),
        Divider(),
        ReportStats(this.dataByMonth),
      ],
    );
  }

  void aggregateDataByMonth() {
    /* Sorts the data by month */
    var dataByMonth = Map();
    for (var i = 0; i < transactions.length; i++) {
      // sorting by month
      var key = "${transactions[i].date.year}-${transactions[i].date.month}";

      if (dataByMonth.containsKey(key)) {
        dataByMonth[key].add(transactions[i]);
      } else {
        dataByMonth[key] = [transactions[i]];
      }
    }

    this.dataByMonth = dataByMonth;
  }
}

class ReportStats extends StatelessWidget {
  final Map transactionsByMonth;

  ReportStats(this.transactionsByMonth); // last 6 months of transactions
  final neutralNumberStyle =
      TextStyle(fontStyle: FontStyle.italic, fontSize: Style.h3);
  final goodNumberStyle = TextStyle(
      fontStyle: FontStyle.italic, fontSize: Style.h3, color: Colors.green);
  final badNumberStyle = TextStyle(
      fontStyle: FontStyle.italic, fontSize: Style.h3, color: Colors.red);

  final textStyle = TextStyle(fontSize: Style.h5);

  int burnRate;
  int avgIncome;
  int spentLastMonth;
  int earnedLastMonth;

  @override
  Widget build(BuildContext context) {
    this.calculateAvgIncomePerMonth();
    this.calculateBurnRate();
    this.calculateSpentLastMonth();
    this.calculateEarnedLastMonth();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        displayStat("Burn Rate: ", burnRate, "\$/month",
            burnRate < 1800 ? goodNumberStyle : badNumberStyle),
        displayStat("Avg Income: ", avgIncome, "\$/month",
            avgIncome > burnRate ? goodNumberStyle : badNumberStyle),
        Divider(),
        displayStat("Spent last month: ", spentLastMonth, "\$",
            spentLastMonth < burnRate ? goodNumberStyle : badNumberStyle),
        displayStat("Earned last month: ", earnedLastMonth, "\$",
            earnedLastMonth > avgIncome ? goodNumberStyle : badNumberStyle),
      ],
    );
  }

  Widget displayStat(String info, int number, String unit, TextStyle style) {
    // number is in cents
    // goodNumber is if we should show the good number style or the bad number style
    return Row(
      children: [
        Text(info + " ", style: textStyle),
        Text(convertToDollars(number).round().toString(), style: style),
        Text(" " + unit, style: textStyle),
      ],
    );
  }

  int sumOutcomeOnMonth(String month) {
    // gets the total spent in the month
    // ignores positive transaction values and transfers
    // returns positive integer
    var transactions = transactionsByMonth[month];
    var amount = 0;

    for (var i = 0; i < transactions.length; i++) {
      var skip = false;
      try {
        var isTransfer = transactions[i].description.substring(0, 9);
        if (isTransfer == 'transfer:') {
          skip = true;
        }
      } catch (RangeError) {}

      if (!skip && transactions[i].amount < 0) {
        amount += transactions[i].amount;
      }
    }

    return amount.abs();
  }

  int sumIncomeOnMonth(String month) {
    // gets the total spent in the month,
    // ignores positive transaction values and transfers
    // returns positive integer
    var transactions = transactionsByMonth[month];
    var amount = 0;

    for (var i = 0; i < transactions.length; i++) {
      var skip = false;
      try {
        var isTransfer = transactions[i].description.substring(0, 9);
        if (isTransfer == 'transfer:') {
          skip = true;
        }
      } catch (RangeError) {}

      if (!skip && transactions[i].amount > 0) {
        amount += transactions[i].amount;
      }
    }

    return amount;
  }

  void calculateBurnRate() {
    int total = 0;
    transactionsByMonth.forEach((k, v) {
      total += sumOutcomeOnMonth(k);
    });

    var avg = total / transactionsByMonth.length.toDouble();

    burnRate = avg.round();

    this.burnRate = burnRate;
  }

  void calculateAvgIncomePerMonth() {
    int total = 0;
    transactionsByMonth.forEach((k, v) {
      total += sumIncomeOnMonth(k);
    });

    var avg = total / transactionsByMonth.length.toDouble();

    avgIncome = avg.round();
  }

  void calculateSpentLastMonth() {
    var now = DateTime.now();
    var lastMonth = DateTime(now.year, now.month - 1, 0);
    spentLastMonth =
        sumOutcomeOnMonth("${lastMonth.year}-${lastMonth.month}").round();
  }

  void calculateEarnedLastMonth() {
    var now = DateTime.now();
    var lastMonth = DateTime(now.year, now.month - 1, 0);
    earnedLastMonth =
        sumIncomeOnMonth("${lastMonth.year}-${lastMonth.month}").round();
  }
}

class BudgetMath {}

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
    List<BudgetModel> positiveBudgets = [];
    budgets.forEach((element) {
      if (element.balance > 0) {
        positiveBudgets.add(element);
      }
    });

    return [
      new charts.Series(
        id: 'Budget Balance Distribution',
        data: positiveBudgets,
        domainFn: (BudgetModel budget, _) => budget.name,
        measureFn: (BudgetModel budget, _) => budget.balance,
        labelAccessorFn: (BudgetModel budget, _) => "${budget.name}",
        colorFn: (BudgetModel budget, __) => getColor(budget),
      ),
    ];
  }

  charts.Color getColor(BudgetModel budget) {
    if (budget.name == maxBudget.name) {
      return charts.MaterialPalette.teal.shadeDefault;
    }
    var shades = charts.MaterialPalette.teal.makeShades(100);
    var index = 100 -
        ((budget.balance.abs().toDouble() /
                    maxBudget.balance.abs().toDouble()) *
                100)
            .round();
    return shades[index];
  }
}
