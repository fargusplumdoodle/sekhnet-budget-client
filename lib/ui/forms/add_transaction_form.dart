import 'package:budget/blocs/add_transaction.dart';
import 'package:budget/globals.dart';
import 'package:budget/ui/forms/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../globals.dart';

class AddTransactionFormWidget extends StatefulWidget {
  @override
  _AddTransactionFormWidgetState createState() =>
      _AddTransactionFormWidgetState();
}

class _AddTransactionFormWidgetState extends State<AddTransactionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  AddTransactionFormData _data = AddTransactionFormData();

  @override
  Widget build(BuildContext context) {
    this._data.budget = budgetStorage[0].name;
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

  void addPostitiveTransaction(
      AddTransactionFormData data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    // amount evaluates to positive
    int amount = (data.amount.abs() * 100).round();
    String date = "${data.date.year}-${data.date.month}-${data.date.day}";

    BlocProvider.of<AddTransactionBloc>(context).add(AddTransactionRequested(
      amount: amount,
      description: data.description,
      budget: get_budget_by_name(data.budget),
      date: date,
    ));
  }

  void addNegativeTransaction(
      AddTransactionFormData data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    // amount evaluates to negative
    int amount = 0 - (data.amount.abs() * 100).round();
    String date = "${data.date.year}-${data.date.month}-${data.date.day}";

    BlocProvider.of<AddTransactionBloc>(context).add(AddTransactionRequested(
      amount: amount,
      description: data.description,
      budget: get_budget_by_name(data.budget),
      date: date,
    ));
  }

  void addIncomeTransaction(AddTransactionFormData data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    int amount = (data.amount * 100).round();
    String date = "${data.date.year}-${data.date.month}-${data.date.day}";

    BlocProvider.of<AddTransactionBloc>(context).add(AddIncomeRequested(
        amount: amount, description: data.description, date: date));
  }
}
