import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:budget/model/budget.dart';
import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  int _id;
  int _amount;
  String _description;
  BudgetModel budget;
  DateTime _date; // TODO: CHANGE TO DATETIME

  TransactionModel(
      this._id, this._amount, this._description, this.budget, this._date);

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String getPrettyDescription() {
    int max = 30;
    if (_description.length > max) {
      return _description.substring(0, max) + "...";
    } else {
      return _description;
    }
  }

  String getPrettyAmount(bool round) {
    // convert to dollars
    String amount = round
        ? convertToDollars(_amount).round().toString()
        : convertToDollars(_amount).toString();
    int max = 12;
    if (amount.length > max) {
      return amount.substring(0, max);
    } else {
      return amount;
    }
  }

  static TransactionModel fromJSON(dynamic json) {
    return TransactionModel(
        json["id"],
        json["amount"],
        json["description"],
        BudgetModel.getBudgetFromId(json["budget"]),
        DateTime.parse(json["date"]));
  }

  dynamic toJSON() {
    return jsonEncode({
      "amount": this.amount,
      "description": this.description,
      "budget": this.budget.id,
      "date": convertDateTimeToString(this.date)
    });
  }

  @override
  List<Object> get props => [_id, _amount, _description, budget, _date];
}
