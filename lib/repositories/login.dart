import 'dart:async';
import 'dart:convert';

import 'package:budget/globals.dart';
import 'package:budget/ui/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'repositories.dart';

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

class LoginApiClient extends ApiClient {
  Future<LoginResponse> login(String username, String password) async {
    final url = '${await getApiHost()}/user/login';
    final body = jsonEncode({
      "username": username,
      "password": password,
    });
    final loginHeaders = {
      "Content-Type": "application/json",
    };

    final response =
        await super.httpClient.post(url, body: body, headers: loginHeaders);
    if (response.statusCode != 200) {
      return LoginResponse(
          errorMsg: "Unable to login with provided credentials",
          success: false);
    }
    final data = jsonDecode(response.body);

    await super.storage.write(key: Constants.TOKEN, value: data["token"]);
    await super.storage.write(key: Constants.USERNAME, value: username);
    await super.storage.write(key: Constants.PASSWORD, value: password);

    return LoginResponse(errorMsg: "", success: true);
  }
}

Future<bool> initLogin() async {
  /*
  Determines how to log in depending on a few factors.
  Returns true if login is required, false if login is not required

  1. If debug:
    -> Set credentials to dev/dev and API URL to staging,
       login directly, return false
  2. Try and log in with existing credentials
    -> If it fails, send user to login screen, return true
  3. If existing credentials dont exist, return true

   TODO: if web, always login
   */
  final loginApiClient = LoginApiClient();
  final storage = new FlutterSecureStorage();

  // 1
  if (!kReleaseMode) {
    print("Starting in debug mode");
    final response = await loginApiClient.login("dev", "dev");
    print("response: ${response.success}: ${response.errorMsg}");
    return !response.success;
  }
  print("Starting in prod mode");

  // 2
  final username = await storage.read(key: Constants.USERNAME);
  final password = await storage.read(key: Constants.PASSWORD);
  if (username != null && password != null) {
    final response = await loginApiClient.login(username, password);
    if (!response.success) {
      // credentials failed, deleting them
      await storage.delete(key: Constants.USERNAME);
      await storage.delete(key: Constants.PASSWORD);
    }
    return !response.success;
  }
  // TODO: get existing credentials from storage and attempt to login
  return true;
}

void logout(BuildContext context) {
  final storage = new FlutterSecureStorage();
  storage.deleteAll();
  SchedulerBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  });
}
