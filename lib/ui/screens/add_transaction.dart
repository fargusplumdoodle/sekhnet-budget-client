import 'package:budget/blocs/add_transaction.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:budget/ui/forms/transaction_forms.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:budget/ui/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionScreen extends StatefulWidget {
  static const routeName = "AddTransactionScreen";

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  List<TransactionModel> createdTransactions = [];
  var _addTransactionRepo = AddTransactionRepository(
      addTransactionApiClient: AddTransactionApiClient());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Base.appBar(),
        drawer: Base.drawer(context),
        body: BlocProvider(
            create: (context) => AddTransactionBloc(
                addTransactionRepository: _addTransactionRepo),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    AddTransactionForm(),
                    Divider(),
                    BlocBuilder<AddTransactionBloc, AddTransactionState>(
                        builder: (context, state) {
                      if (state is AddTransactionInitial) {
                        if (this.createdTransactions.length == 0) {
                          return Center(
                              child: Text(
                            "Your added transactions will show here",
                          ));
                        }
                      }

                      if (state is AddTransactionLoadInProgress) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (state is AddTransactionLoadSuccess) {
                        createdTransactions.insert(0, state.transaction);
                      }

                      if (state is AddIncomeLoadSuccess) {
                        state.transactions.addAll(createdTransactions);
                        createdTransactions = state.transactions;
                      }

                      return TransactionList(createdTransactions, 1000, true);
                    })
                  ],
                ))));
  }
}
