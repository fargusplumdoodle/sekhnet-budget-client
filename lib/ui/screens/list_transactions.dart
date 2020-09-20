import 'package:budget/blocs/blocs.dart';
import 'package:budget/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListTransactions extends StatefulWidget {
  static const routeName = "/listAllTransactions";
  @override
  _ListTransactionsState createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Base.appBar(),
        drawer: Base.drawer(context),
        body: BlocProvider(
            create: (context) => TransactionBloc(),
            child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
              if (state is TransactionInitial) {
                BlocProvider.of<TransactionBloc>(context)
                    .add(AllTransactionsRequested());
              }
              if (state is TransactionLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is TransactionLoadSuccess) {
                return TransactionList(state.transactions, 100, true);
              }
              return Center(
                  child: Text("Unable to fetch transactions",
                      style: TextStyle(color: Colors.red)));
            })));
  }
}
