import 'package:budget/blocs/blocs.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:budget/ui/forms/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../globals.dart';

class TransferFundsForm extends StatefulWidget {
  @override
  _TransferFundsFormState createState() => _TransferFundsFormState();
}

class _TransferFundsFormState extends State<TransferFundsForm> {
  final _formKey = GlobalKey<FormState>();
  // we will temporarily get the data from fromTrans, this is because
  // all of the transaction form elements take TransactionModels as arguments
  final fromTrans = TransactionModel(null, 0, "", budgetStorage[0], null);
  final toTrans = TransactionModel(null, 0, "", budgetStorage[1], null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TransactionAmountInput(fromTrans),
          TransactionDescriptionInput(fromTrans),
          TransactionBudgetDropdown(fromTrans),
          TransactionBudgetDropdown(toTrans),
          RaisedButton(
              child: Text("TRANSFER"),
              onPressed: () {
                this._formKey.currentState.save();

                final data = TransferFundsData();
                data.amount = fromTrans.amount;
                data.description = fromTrans.description;
                data.fromBudget = fromTrans.budget;
                data.toBudget = toTrans.budget;

                BlocProvider.of<TransactionBloc>(context)
                    .add(TransferFundsRequested(data: data));
              })
        ],
      ),
    );
  }
}
