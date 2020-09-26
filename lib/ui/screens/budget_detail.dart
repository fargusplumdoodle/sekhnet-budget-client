import 'package:budget/blocs/transaction.dart';
import 'package:budget/globals.dart';
import 'package:budget/model/budget.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:budget/ui/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetDetail extends StatelessWidget {
  static const routeName = 'budget_detail';
  final int _maxTransactions = 20;

  @override
  Widget build(BuildContext context) {
    final BudgetModel budget = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: Base.appBar("Budget: ${budget.name}"),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.info)), // TODO: make reporting
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  budget.name,
                  style: TextStyle(fontSize: Style.h1),
                ),
              ),
            ),
            BudgetCard(budget),
            Divider(),
            BlocProvider(
                create: (context) => TransactionBloc(),
                child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                  if (state is TransactionInitial) {
                    BlocProvider.of<TransactionBloc>(context).add(
                        TransactionRequested(
                            budgetID: budget.id,
                            maxTransactions: _maxTransactions));
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is TransactionLoadInProgress) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is TransactionLoadSuccess) {
                    return Expanded(
                        child: TransactionList(
                            state.transactions, _maxTransactions, false));
                  }

                  return Center(
                      child: Text("Unable to fetch transactions",
                          style: TextStyle(color: Colors.red)));
                }))
          ],
        ),
      ),
    );
  }
}

Widget BudgetCard(BudgetModel budget) {
  return Card(
      child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '${budget.percentage}%',
              style: TextStyle(fontSize: Style.h2),
            )),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            '${budget.getPrettyBalance(true)}\$',
            style: TextStyle(fontSize: Style.h2),
          ),
        )
      ],
    ),
  ));
}
