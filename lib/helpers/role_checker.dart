import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talacare/config.dart';

Future<bool> checkRole(http.Client client, String email) async {
  Uri url = Uri.parse('$urlBackEnd/auth/check_role/');
  try {
    http.Response response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    Map<String, dynamic> parsedResponse = json.decode(response.body);
    String role = parsedResponse['role'];
    if (role == 'ADMIN') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
