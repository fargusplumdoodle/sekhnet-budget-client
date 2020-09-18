import 'model/budget.dart';

const String API_HOST = "http://10.0.0.85/api/v2";
const String USERNAME = "dev";
const String PASSWORD = "dev";
String token = 'ff41f973cda1d22805d642337da8d5f9b9078714';

Map<String, String> get headers => {
      "Content-Type": "application/json",
      "Authorization": 'Token $token',
    };

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
