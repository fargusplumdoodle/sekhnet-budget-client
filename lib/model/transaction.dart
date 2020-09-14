import 'package:budget/model/budget.dart';
import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  int _id;
  String _amount;
  String _description;
  BudgetModel budget;
  String _date;

  TransactionModel(
      this._id, this._amount, this._description, this.budget, this._date);

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get amount => _amount;

  set amount(String value) {
    _amount = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String getPrettyDescription() {
    int max = 15;
    if (_description.length > max) {
      return _description.substring(0, max) + "...";
    } else {
      return _description;
    }
  }

  String getPrettyAmount() {
    int max = 6;
    if (_amount.length > max) {
      return _amount.substring(0, max);
    } else {
      return _amount;
    }
  }

  @override
  List<Object> get props => [_id, _amount, _description, budget, _date];
}
