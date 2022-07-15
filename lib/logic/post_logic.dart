import 'dart:convert';

import 'package:http/http.dart' as http;

class HTTPPostLogic {
  HTTPPostLogic();

  Future<bool> postData(reqObject) async {
    try {
      final res = await http.post(
        Uri.parse('https://handwritingdata.herokuapp.com/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reqObject),
      );

      if (res.statusCode == 200 && json.decode(res.body)['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      
    }
  }
}
