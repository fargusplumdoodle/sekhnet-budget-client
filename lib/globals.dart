const String API_HOST = "http://172.19.0.3:8000/api/v1";
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
