import 'package:budget/model/budget.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AddTransactionForm extends StatefulWidget {
  static const routeName = "AddTransaction";

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormData {
  String amount;
  String description;
  DateTime date;
  String budget;
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = get_temp_budget_names()[0];
  _AddTransactionFormData _data = _AddTransactionFormData();

  @override
  Widget build(BuildContext context) {
    this._data.budget = this.dropdownValue;

    return Scaffold(
      appBar: Base.appBar(),
      drawer: Base.drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                        this._data.amount = value;
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
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 4,
                        color: Colors.deepPurpleAccent,
                      ),
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        this._data.budget = newValue;
                      },
                      items: get_temp_budget_names()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
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

                              this.addPostitiveTransaction(_data);
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

                              this.addNegativeTransaction(_data);
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
                              this.addIncomeTransaction(_data);
                            }
                          },
                          child: Icon(Icons.account_balance_wallet),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  void addPostitiveTransaction(_AddTransactionFormData data) {
    _formKey.currentState.save();
    print("eyy adding the postitibve trasnsaciton eyy");
    print(data.amount);
    print(data.description);
    print(data.date);
    print(data.budget);
  }

  void addNegativeTransaction(_AddTransactionFormData data) {
    _formKey.currentState.save();
    print("eyy adding the negative trasnsaciton eyy");
    print(data.amount);
    print(data.description);
    print(data.date);
    print(data.budget);
  }

  void addIncomeTransaction(_AddTransactionFormData data) {
    _formKey.currentState.save();
    print("eyy adding the income trasnsaciton eyy");
    print(data.amount);
    print(data.description);
    print(data.date);
    print(data.budget);
  }
}
