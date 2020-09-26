import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';

abstract class ApiClient {
  final storage = new FlutterSecureStorage();
  final httpClient = new http.Client();

  dynamic getHeaders() async {
    var token = await this.storage.read(key: Constants.TOKEN);
    return {
      "Content-Type": "application/json",
      "Authorization": 'Token $token',
    };
  }

  Future<String> getApiHost() async {
    if (!kReleaseMode) {
      return STAGING_API_HOST;
    }
    String apiHost = await this.storage.read(key: Constants.API_HOST);
    if (apiHost == null) {
      apiHost = API_HOST;
      await this.storage.write(key: Constants.API_HOST, value: API_HOST);
    }
    return apiHost;
  }
}
