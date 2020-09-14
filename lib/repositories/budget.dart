import 'dart:async';
import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BudgetRepository {
  final BudgetApiClient budgetApiClient;

  BudgetRepository({@required this.budgetApiClient})
      : assert(budgetApiClient != null);

  Future<List<BudgetModel>> getBudgets() async {
    return await budgetApiClient.getBudgets();
  }
}

class BudgetApiClient {
  final http.Client httpClient;

  BudgetApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<BudgetModel>> getBudgets() async {
    final url = '$API_HOST/budget';

    final response = await this.httpClient.get(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('error getting budget list');
    }
    final data = jsonDecode(response.body) as List;

    var budgetList = new List<BudgetModel>();
    data.forEach((dynamic json) {
      budgetList.add(BudgetModel.fromJSON(json));
    });

    return budgetList;
  }
}
