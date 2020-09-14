import 'package:budget/blocs/blocs.dart';
import 'package:budget/ui/widgets/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Budget List')),
        body: Center(
            child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                BlocProvider.of<BudgetBloc>(context).add(BudgetRequested());
              },
            ),
            BlocBuilder<BudgetBloc, BudgetState>(builder: (context, state) {
              if (state is BudgetInitial) {
                return Center(child: Text("budget is initial"));
              }
              if (state is BudgetLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is BudgetLoadSuccess) {
                return BudgetDashboardWidget(state.budgets);
              } else {
                return Center(
                    child: Text("something went wrong!",
                        style: TextStyle(color: Colors.red)));
              }
            }),
          ],
        )));
  }
}
