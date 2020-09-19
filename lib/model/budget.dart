import 'package:budget/globals.dart';
import 'package:equatable/equatable.dart';

class BudgetModel extends Equatable {
  int _id;
  String _name;
  int _percentage;
  int _balance;
  int _init_balance;

  int get id => _id;

  BudgetModel(this._id, this._name, this._percentage, this._balance,
      this._init_balance);

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  int get init_balance => _init_balance;

  set init_balance(int value) {
    _init_balance = value;
  }

  int get balance => _balance;

  String getPrettyBalance(bool round) {
    // convert to dollars
    String amount = round
        ? convertToDollars(_balance).round().toString()
        : convertToDollars(_balance).toString();
    int max = 12;
    if (amount.length > max) {
      return amount.substring(0, max);
    } else {
      return amount;
    }
  }

  set balance(int value) {
    _balance = value;
  }

  int get percentage => _percentage;

  set percentage(int value) {
    _percentage = value;
  }

  set name(String value) {
    _name = value;
  }

  @override
  List<Object> get props => [_id, _name, _percentage, _balance, _init_balance];

  static BudgetModel fromJSON(dynamic json) {
    int id = json["id"];
    String name = json["name"];
    int percentage = json["percentage"];
    int balance = json["balance"];
    int initialBalance = json["initial_balance"];
    return BudgetModel(id, name, percentage, balance, initialBalance);
  }

  static BudgetModel getBudgetFromId(int id) {
    for (var i = 0; i < budgetStorage.length; i++) {
      if (budgetStorage[i].id == id) {
        return budgetStorage[i];
      }
    }
    return null;
  }
}
