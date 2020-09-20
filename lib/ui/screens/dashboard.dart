import 'package:budget/blocs/blocs.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:budget/ui/widgets/base.dart';
import 'package:budget/ui/widgets/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatelessWidget {
  static const routeName = '/';
  var _budgetRepo = BudgetRepository(budgetApiClient: BudgetApiClient());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Base.appBar(),
        drawer: Base.drawer(context),
        floatingActionButton: Base.floatingActionButton(context),
        body: Container(
            padding: EdgeInsets.all(8.8),
            child: BlocProvider(
                create: (context) => BudgetBloc(budgetRepository: _budgetRepo),
                child: BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, state) {
                  if (state is BudgetInitial) {
                    BlocProvider.of<BudgetBloc>(context).add(BudgetRequested());
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is BudgetLoadInProgress) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is BudgetLoadSuccess) {
                    return Column(
                      children: <Widget>[
                        StatusCard(state.budgets),
                        BudgetDashboardWidget(state.budgets),
                      ],
                    );
                  } else {
                    return Center(
                        child: Text("Unable to fetch budgets",
                            style: TextStyle(color: Colors.red)));
                  }
                }))));
  }
}
