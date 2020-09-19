import 'dart:async';
import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class AddTransactionRepository {
  final AddTransactionApiClient addTransactionApiClient;

  AddTransactionRepository({@required this.addTransactionApiClient})
      : assert(addTransactionApiClient != null);

  Future<TransactionModel> addTransaction(
      int amount, String description, BudgetModel budget, String date) async {
    return await addTransactionApiClient.addTransaction(
        amount, description, budget, date);
  }

  Future<List<TransactionModel>> addIncome(
      int amount, String description, String date) async {
    return await addTransactionApiClient.addIncome(amount, description, date);
  }
}

class AddTransactionApiClient {
  final http.Client httpClient;

  AddTransactionApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<TransactionModel> addTransaction(
      int amount, String description, BudgetModel budget, String date) async {
    final url = '$API_HOST/transaction/';
    final body = jsonEncode({
      "amount": amount,
      "description": description,
      "budget": budget.id,
      "date": date
    });

    final response =
        await this.httpClient.post(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      throw Exception(
          'error creating transaction: ${response.statusCode}: ${response.body}');
    }
    final data = jsonDecode(response.body);

    return TransactionModel.fromJSON(data);
  }

  Future<List<TransactionModel>> addIncome(
      int amount, String description, String date) async {
    final url = '$API_HOST/transaction/income/';
    final body = jsonEncode(
        {"amount": amount, "description": description, "date": date});

    final response =
        await this.httpClient.post(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      throw Exception(
          'error creating transaction: ${response.statusCode}: ${response.body}');
    }
    final data = jsonDecode(response.body) as List;

    var transactionList = new List<TransactionModel>();
    for (int i = 0; i < data.length; i++) {
      transactionList.add(TransactionModel.fromJSON(data[i]));
    }

    return transactionList;
  }
}
