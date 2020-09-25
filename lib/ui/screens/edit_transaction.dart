import 'package:budget/model/models.dart';
import 'package:budget/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
        body: EditTransactionForm());
  }
}
