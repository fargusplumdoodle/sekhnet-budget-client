import 'package:budget/model/budget.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:flutter/material.dart';

class BudgetDetail extends StatelessWidget {
  static const routeName = 'budget_detail';
  @override
  Widget build(BuildContext context) {
    final BudgetModel budget = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: Base.appBar(),
      body: Center(child: Text(budget.name)),
    );
  }
}
