import 'package:budget/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ui.dart';

class TransferFunds extends StatelessWidget {
  static const routeName = "/transferFunds";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Base.appBar("Transfer Funds"),
        drawer: Base.drawer(context),
        body: BlocProvider(
            create: (context) => TransactionBloc(),
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                var widgets = <Widget>[TransferFundsForm()];

                if (state is TransactionLoadInProgress) {
                  widgets.add(CircularProgressIndicator());
                }
                if (state is TransactionLoadFailure) {
                  widgets.add(Text(
                    "Failed to update transaction: ${state.errorMsg}",
                    style: TextStyle(color: Colors.red),
                  ));
                }
                if (state is TransactionLoadSuccess) {
                  widgets.add(Divider());
                  widgets.add(TransactionList(state.transactions, 2, true));
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: widgets,
                  ),
                );
              },
            )));
  }
}
