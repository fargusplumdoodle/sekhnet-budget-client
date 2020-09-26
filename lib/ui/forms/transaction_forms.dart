import 'package:budget/blocs/add_transaction.dart';
import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:budget/ui/forms/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../globals.dart';

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  TransactionModel _data =
      TransactionModel(0, 0, "", budgetStorage[0], DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TransactionAmountInput(this._data),
          TransactionDescriptionInput(this._data),
          TransactionDateInput(this._data),
          TransactionBudgetDropdown(this._data),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      this.addPostitiveTransaction(_data, context);
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      this.addNegativeTransaction(_data, context);
                    }
                  },
                  child: Icon(Icons.remove),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      this.addIncomeTransaction(_data, context);
                    }
                  },
                  child: Icon(Icons.account_balance_wallet),
                ),
              ),
            ],
          )
        ]));
  }

  void addPostitiveTransaction(TransactionModel data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    // amount evaluates to positive
    BlocProvider.of<AddTransactionBloc>(context)
        .add(AddTransactionRequested(trans: data));
  }

  void addNegativeTransaction(TransactionModel data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    // amount evaluates to negative
    data.amount = 0 - data.amount.abs();
    BlocProvider.of<AddTransactionBloc>(context)
        .add(AddTransactionRequested(trans: data));
  }

  void addIncomeTransaction(TransactionModel data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    BlocProvider.of<AddTransactionBloc>(context).add(AddIncomeRequested(
        amount: data.amount, description: data.description, date: data.date));
  }
}

class EditTransactionForm extends StatefulWidget {
  @override
  _EditTransactionFormState createState() => _EditTransactionFormState();
}

class _EditTransactionFormState extends State<EditTransactionForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TransactionModel transaction =
        ModalRoute.of(context).settings.arguments;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TransactionAmountInput(transaction),
          TransactionDescriptionInput(transaction),
          TransactionDateInput(transaction),
          TransactionBudgetDropdown(transaction),
          RaisedButton(
            child: Text("SUBMIT"),
            onPressed: () {
              this._formKey.currentState.save();
              BlocProvider.of<AddTransactionBloc>(context)
                  .add(UpdateTransactionRequested(trans: transaction));
            },
          )
        ],
      ),
    );
  }
}
