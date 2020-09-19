import 'package:budget/blocs/add_transaction.dart';
import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../globals.dart';

class _AddTransactionFormData {
  double amount;
  String description;
  DateTime date;
  String budget;
}

class AddTransactionFormWidget extends StatefulWidget {
  @override
  _AddTransactionFormWidgetState createState() =>
      _AddTransactionFormWidgetState();
}

class _AddTransactionFormWidgetState extends State<AddTransactionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = budgetStorage[0].name;
  _AddTransactionFormData _data = _AddTransactionFormData();

  @override
  Widget build(BuildContext context) {
    this._data.budget = this.dropdownValue;
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
              // The validator receives the text that the user has entered.
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter amount",
                hintText: "Amount of money to add/subtract",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String value) {
                this._data.amount = double.parse(value);
              }),
          TextFormField(
              // The validator receives the text that the user has entered.
              decoration: InputDecoration(
                labelText: "Transaction Description",
                hintText: "What the transaction was for",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String value) {
                this._data.description = value;
              }),
          InputDatePickerFormField(
              firstDate: DateTime(2000, 11, 3),
              lastDate: DateTime(2077, 11, 3),
              initialDate: DateTime.now(),
              onDateSaved: (DateTime value) {
                this._data.date = value;
              }),
          DropdownButton(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              hint: Text("Budget"),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.tealAccent),
              underline: Container(
                height: 4,
                color: Colors.tealAccent,
              ),
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
                this._data.budget = newValue;
              },
              items: budgetStorage
                  .map<DropdownMenuItem<String>>((BudgetModel budget) {
                return DropdownMenuItem<String>(
                    value: budget.name,
                    child: Center(
                      child: Text(
                        budget.name,
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
              }).toList()),
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
      _AddTransactionFormData data, BuildContext context) {
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
      _AddTransactionFormData data, BuildContext context) {
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

  void addIncomeTransaction(
      _AddTransactionFormData data, BuildContext context) {
    _formKey.currentState.save();
    // database uses cents, add positive transaction will always have the
    int amount = (data.amount * 100).round();
    String date = "${data.date.year}-${data.date.month}-${data.date.day}";

    BlocProvider.of<AddTransactionBloc>(context).add(AddIncomeRequested(
        amount: amount, description: data.description, date: date));
  }
}
