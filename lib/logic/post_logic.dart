import 'dart:convert';

import 'package:http/http.dart' as http;

class HTTPPostLogic {
  HTTPPostLogic();

  Future<http.Response> postData(reqObject) {
    return http.post(
      Uri.parse('http://6672-14-139-226-132.ngrok.io/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reqObject),
    );
  }
}
