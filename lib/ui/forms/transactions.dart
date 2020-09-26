import 'package:budget/model/models.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class TransactionBudgetDropdown extends StatefulWidget {
  final TransactionModel _data;
  String dropdownValue = budgetStorage[0].name;

  TransactionBudgetDropdown(this._data);
  @override
  _TransactionBudgetDropdownState createState() =>
      _TransactionBudgetDropdownState(this._data);
}

class _TransactionBudgetDropdownState extends State<TransactionBudgetDropdown> {
  final TransactionModel _data;
  String dropDownValue;

  _TransactionBudgetDropdownState(this._data);

  @override
  Widget build(BuildContext context) {
    dropDownValue = this._data.budget.name;
    return DropdownButton(
        value: dropDownValue,
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
        onChanged: (dynamic newValue) {
          setState(() {
            dropDownValue = newValue;
          });
          this._data.budget = get_budget_by_name(newValue);
        },
        items:
            budgetStorage.map<DropdownMenuItem<String>>((BudgetModel budget) {
          return DropdownMenuItem<String>(
              value: budget.name,
              child: Center(
                child: Text(
                  budget.name,
                  style: TextStyle(fontSize: 20),
                ),
              ));
        }).toList());
  }
}

class TransactionDescriptionInput extends StatelessWidget {
  final TransactionModel _data;
  final _controller = TextEditingController();

  TransactionDescriptionInput(this._data);

  @override
  Widget build(BuildContext context) {
    this._controller.text = this._data.description;
    return TextFormField(
        // The validator receives the text that the user has entered.
        controller: _controller,
        decoration: InputDecoration(
          labelText: "Transaction Description",
          hintText: "What the transaction was for",
          suffixIcon: IconButton(
            onPressed: () => {this._controller.clear()},
            icon: Icon(Icons.clear),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
        onSaved: (String value) {
          this._data.description = value;
        });
  }
}

class TransactionDateInput extends StatelessWidget {
  final TransactionModel _data;

  TransactionDateInput(this._data);

  @override
  Widget build(BuildContext context) {
    // TODO: USE SUPPLIED TRANSACTIONS DATE
    return InputDatePickerFormField(
        firstDate: DateTime(2000, 11, 3),
        lastDate: DateTime(2077, 11, 3),
        initialDate: DateTime.now(),
        onDateSaved: (DateTime value) {
          this._data.date = value;
        });
  }
}

class TransactionAmountInput extends StatelessWidget {
  final TransactionModel _data;
  final _controller = TextEditingController();

  TransactionAmountInput(this._data);

  @override
  Widget build(BuildContext context) {
    this._controller.text = convertToDollars(this._data.amount).toString();
    return TextFormField(
        // The validator receives the text that the user has entered.
        keyboardType: TextInputType.number,
        controller: this._controller,
        decoration: InputDecoration(
          labelText: "Enter amount",
          hintText: "Amount of money to add/subtract",
          suffixIcon: IconButton(
            onPressed: () => {this._controller.clear()},
            icon: Icon(Icons.clear),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: (String value) {
          this._data.amount = (double.parse(value) * 100).round();
        });
  }
}
