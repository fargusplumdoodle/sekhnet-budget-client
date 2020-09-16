import 'dart:convert';

import 'package:http/http.dart' as http;

import '../globals.dart';

Future<void> login() async {
  /*
  Logs in with credentials from globals.dart
  and sets global token variable
   */
  var client = http.Client();
  final url = "$API_HOST/user/login";
  final body = {
    "username": USERNAME,
    "password": PASSWORD,
  };

  print("logging in");
  final response = await client.post(url, body: body);

  if (response.statusCode != 200) {
    throw Exception('Unable to log in! Response: ${response.body}');
  }
  final data = jsonDecode(response.body) as Map<String, dynamic>;

  token = data['token'];
  print("log in success! Token: " + token);
}
