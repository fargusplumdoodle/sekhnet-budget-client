import 'package:budget/model/budget.dart';
import 'package:budget/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final budget = BudgetModel(2, 'food', 3, 32, 0);

final transactions = [
  TransactionModel(1, '-10', 'milk', budget, '2020-10-01'),
  TransactionModel(2, '-11.111', 'peanuts', budget, '2020-10-11'),
  TransactionModel(3, '41.35', 'big peanuts', budget, '2020-10-11'),
  TransactionModel(1, '-10', 'milk', budget, '2020-10-01'),
  TransactionModel(
      2,
      '-11',
      'a lot and a lot and a lot of peanuts like oh my freaking gosh my dude',
      budget,
      '2020-10-11'),
  TransactionModel(3, '-41', 'big peanuts', budget, '2020-10-11'),
  TransactionModel(1, '-10', 'milk', budget, '2020-10-01'),
  TransactionModel(2, '-11', 'peanuts', budget, '2020-10-11'),
  TransactionModel(3, '-41', 'big peanuts', budget, '2020-10-11'),
  TransactionModel(1, '-10', 'milk', budget, '2020-10-01'),
  TransactionModel(2, '-11', 'peanuts', budget, '2020-10-11'),
  TransactionModel(3, '-41', 'big peanuts', budget, '2020-10-11'),
  TransactionModel(1, '-10', 'milk', budget, '2020-10-01'),
  TransactionModel(2, '-11', 'peanuts', budget, '2020-10-11'),
  TransactionModel(3, '-41', 'big peanuts', budget, '2020-10-11')
];

class TransactionList extends StatelessWidget {
  /*
  Returns the number of transactions specififed from
  the specified budget
   */
  final BudgetModel budget;
  final int numberOfTransactions;
  final bool showBudgetName;

  TransactionList(this.budget, this.numberOfTransactions, this.showBudgetName);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: numberOfTransactions < transactions.length
            ? numberOfTransactions
            : transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Text(
                transactions[index].getPrettyAmount(),
              ),
              title: Text(transactions[index].getPrettyDescription()),
              subtitle: Text(
                showBudgetName
                    ? '${transactions[index].date}  -  ${transactions[index].budget.name}'
                    : transactions[index].date,
              ),
            ),
          );
        });
  }
}
