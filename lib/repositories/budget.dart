import 'dart:async';
import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class BudgetRepository {
  final BudgetApiClient budgetApiClient;

  BudgetRepository({@required this.budgetApiClient})
      : assert(budgetApiClient != null);

  Future<List<BudgetModel>> getBudgets() async {
    return await budgetApiClient.getBudgets();
  }

  Future<List<TransactionModel>> getTransactions(
      int budgetID, int maxTransactions) async {
    return await budgetApiClient.getTransactions(budgetID, maxTransactions);
  }
}

class BudgetApiClient extends ApiClient {
  Future<List<BudgetModel>> getBudgets() async {
    final url = '${await getApiHost()}/budget';

    final response =
        await this.httpClient.get(url, headers: await getHeaders());
    if (response.statusCode != 200) {
      throw Exception('error getting budget list');
    }
    final data = jsonDecode(response.body) as List;

    var budgetList = new List<BudgetModel>();
    data.forEach((dynamic json) {
      budgetList.add(BudgetModel.fromJSON(json));
    });

    // TODO: replace with actual database
    budgetStorage = budgetList;

    return budgetList;
  }

  Future<List<TransactionModel>> getTransactions(
      int budgetID, int maxTransactions) async {
    final url = '${await getApiHost()}/transaction/?budget=$budgetID';

    final response =
        await this.httpClient.get(url, headers: await getHeaders());
    if (response.statusCode != 200) {
      throw Exception('error getting transaction list');
    }
    final data = jsonDecode(response.body) as List;

    var transactionList = new List<TransactionModel>();
    data.forEach((dynamic json) {
      transactionList.add(TransactionModel.fromJSON(json));
    });

    return transactionList;
  }
}
