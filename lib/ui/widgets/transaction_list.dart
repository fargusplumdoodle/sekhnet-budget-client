import 'package:budget/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../ui.dart';

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
          return GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, EditTransaction.routeName,
                  arguments: transactions[index])
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      transactions[index].getPrettyAmount(false),
                    ),
                  ),
                ),
                title: Text(transactions[index].getPrettyDescription()),
                subtitle: Text(
                  showBudgetName
                      ? '${transactions[index].date}  -  ${transactions[index].budget.name}'
                      : transactions[index].date,
                ),
              ),
            ),
          );
        });
  }
}
