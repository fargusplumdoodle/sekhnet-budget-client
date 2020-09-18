import 'package:budget/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransactionList extends StatelessWidget {
  /*
  Returns the number of transactions specified from
  the specified budget
   */
  final List<TransactionModel> transactions;
  final int numberOfTransactions;
  final bool showBudgetName;

  TransactionList(
      this.transactions, this.numberOfTransactions, this.showBudgetName);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        shrinkWrap: true,
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
