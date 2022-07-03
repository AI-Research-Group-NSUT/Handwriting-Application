import 'dart:convert';

import 'package:http/http.dart' as http;

class HTTPPostLogic {
  HTTPPostLogic();

  Future<http.Response> postData(reqObject) {
    return http.post(
      Uri.parse('https://handwritingdata.herokuapp.com/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reqObject),
    );
  }
}
