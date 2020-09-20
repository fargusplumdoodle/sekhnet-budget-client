import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

abstract class ApiClient {
  final storage = new FlutterSecureStorage();
  final httpClient = new http.Client();

  dynamic getHeaders() async {
    var token = await this.storage.read(key: "token");
    return {
      "Content-Type": "application/json",
      "Authorization": 'Token $token',
    };
  }
}
