class BudgetModel {
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
}

List<String> get_temp_budget_names() {
  return ['food', 'housing', 'personal'];
}
