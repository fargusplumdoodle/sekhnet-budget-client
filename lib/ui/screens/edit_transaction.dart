import 'package:budget/blocs/blocs.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:budget/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTransaction extends StatefulWidget {
  static const routeName = "/editTransaction";
  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  @override
  Widget build(BuildContext context) {
    final TransactionModel transaction =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: Base.appBar(),
        drawer: Base.drawer(context),
        body: BlocProvider(
            create: (context) => AddTransactionBloc(
                addTransactionRepository: AddTransactionRepository(
                    addTransactionApiClient: AddTransactionApiClient())),
            child: BlocBuilder<AddTransactionBloc, AddTransactionState>(
                builder: (context, state) {
              var widgets = <Widget>[EditTransactionForm()];

              if (state is AddTransactionLoadInProgress) {
                widgets.add(CircularProgressIndicator());
              }
              if (state is AddTransactionLoadFailure) {
                widgets.add(Text(
                  "Failed to update transaction",
                  style: TextStyle(color: Colors.red),
                ));
              }
              if (state is AddTransactionLoadSuccess) {
                widgets.add(Text(
                  "Success!",
                  style: TextStyle(color: Colors.green),
                ));
              }

              return Column(
                children: widgets,
              );
            })));
  }
}
//
