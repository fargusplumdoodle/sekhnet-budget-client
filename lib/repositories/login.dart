import 'dart:async';
import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class LoginResponse {
  final String errorMsg;
  final bool success;

  LoginResponse({@required this.errorMsg, @required this.success})
      : assert(errorMsg != null && success != null);
}

class LoginRepository {
  final LoginApiClient loginClient;

  LoginRepository({@required this.loginClient}) : assert(loginClient != null);

  Future<LoginResponse> login(String username, String password) async {
    return await loginClient.login(username, password);
  }
}

class LoginApiClient {
  final http.Client httpClient;

  LoginApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<LoginResponse> login(String username, String password) async {
    final url = '$API_HOST/user/login';
    final body = jsonEncode({
      "username": username,
      "password": password,
    });
    final loginHeaders = {
      "Content-Type": "application/json",
    };

    final response =
        await this.httpClient.post(url, body: body, headers: loginHeaders);
    if (response.statusCode != 200) {
      return LoginResponse(
          errorMsg: "Unable to login with provided credentials",
          success: false);
    }
    final data = jsonDecode(response.body);
    token = data["token"];
    return LoginResponse(errorMsg: "", success: true);
  }
}

Future<bool> initLogin() async {
  /*
  Determines how to log in depending on a few factors.
  Returns if login screen is required or not

  1. If debug:
    -> Set credentials to dev/dev and API URL to staging,
       login directly, return false
  2. Try and log in with existing credentials
    -> If it fails, send user to login screen, return true
  3. If existing credentials dont exist, return true

   TODO: if web, always login
   */
  final loginApiClient = LoginApiClient(httpClient: http.Client());
  // 1
  if (!kReleaseMode) {
    print("Starting in debug mode");
    API_HOST = "http://10.0.0.85/api/v2";
    final response = await loginApiClient.login("dev", "dev");
    print("response: ${response.success}: ${response.errorMsg}");
    return !response.success;
  }
  print("Starting in prod mode");

  // 2
  // TODO: get existing credentials from storage and attempt to login

  return true;
}
