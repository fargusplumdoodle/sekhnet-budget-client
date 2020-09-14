import 'package:budget/blocs/blocs.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:budget/ui/screens/tmp_budget_list_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class TmpBudgetList extends StatelessWidget {
  static final routeName = "/asdfasdf";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetBloc(
          budgetRepository: BudgetRepository(
              budgetApiClient: BudgetApiClient(httpClient: http.Client()))),
      child: BudgetInfo(),
    );
  }
}
