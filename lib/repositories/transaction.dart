import 'dart:async';
import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/api_client.dart';
import 'package:meta/meta.dart';

class AddTransactionRepository {
  final AddTransactionApiClient addTransactionApiClient;

  AddTransactionRepository({@required this.addTransactionApiClient})
      : assert(addTransactionApiClient != null);

  Future<TransactionModel> addTransaction(TransactionModel trans) async {
    return await addTransactionApiClient.addTransaction(trans);
  }

  Future<TransactionModel> updateTransaction(TransactionModel trans) async {
    return await addTransactionApiClient.updateTransaction(trans);
  }

  Future<List<TransactionModel>> addIncome(
      int amount, String description, DateTime date) async {
    return await addTransactionApiClient.addIncome(amount, description, date);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    return await addTransactionApiClient.getAllTransactions();
  }
}

class AddTransactionApiClient extends ApiClient {
  Future<TransactionModel> addTransaction(TransactionModel trans) async {
    final url = '${await getApiHost()}/transaction/';
    final response = await this
        .httpClient
        .post(url, headers: await getHeaders(), body: trans.toJSON());
    if (response.statusCode != 201) {
      throw Exception(
          'error creating transaction: ${response.statusCode}: ${response.body}');
    }
    final data = jsonDecode(response.body);

    return TransactionModel.fromJSON(data);
  }

  Future<TransactionModel> updateTransaction(TransactionModel trans) async {
    final url = '${await getApiHost()}/transaction/${trans.id}/';

    print(trans.toJSON());
    final response = await this
        .httpClient
        .put(url, headers: await getHeaders(), body: trans.toJSON());

    print('repsonse: ${response.statusCode}: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception(
          'error updating transaction: ${response.statusCode}: ${response.body}');
    }
    final data = jsonDecode(response.body);

    return TransactionModel.fromJSON(data);
  }

  Future<List<TransactionModel>> addIncome(
      int amount, String description, DateTime date) async {
    final url = '${await getApiHost()}/transaction/income/';
    final body = jsonEncode({
      "amount": amount,
      "description": description,
      "date": convertDateTimeToString(date)
    });

    final response = await this
        .httpClient
        .post(url, headers: await getHeaders(), body: body);
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

  Future<List<TransactionModel>> getAllTransactions() async {
    final url = '${await getApiHost()}/transaction/';

    final response =
        await this.httpClient.get(url, headers: await getHeaders());
    if (response.statusCode != 200) {
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
