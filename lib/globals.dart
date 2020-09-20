import 'model/budget.dart';

const API_HOST = "http://10.0.0.84/api/v2";
const STAGING_API_HOST = "http://10.0.0.85/api/v2";

class Style {
  static const double h1 = 55;
  static const double h2 = 40;
}

List<BudgetModel> budgetStorage; // TODO: replace with actual database

BudgetModel get_budget_by_name(String name) {
  for (int i = 0; i < budgetStorage.length; i++) {
    if (budgetStorage[i].name == name) {
      return budgetStorage[i];
    }
  }
  return null;
}

double convertToDollars(int amount) {
  return amount / 100;
}

int convertToCents(int amount) {
  return amount * 100;
}

class Constants {
  static const USERNAME = "username";
  static const PASSWORD = "password";
  static const TOKEN = "token";
  static const API_HOST = "API_HOST";
}
