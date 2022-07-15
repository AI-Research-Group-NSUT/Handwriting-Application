import 'dart:convert';

import 'package:http/http.dart' as http;

class HTTPGetLogic {
  final String url = 'https://handwritingdata.herokuapp.com/get';

  Future<CharacterResponse?> getData() async {
    try {
      final res = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final characterData = CharacterResponse.fromJson(data);

        return Future.value(characterData);
      } else {
        return null;
      }
    } catch (e) {
      print('Error');
      return null;
    }
  }
}

class CharacterResponse {
  final int index;
  final List<dynamic> data;

  CharacterResponse(this.index, this.data);

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    return CharacterResponse(json['index'], json['data']);
  }

  // @override
  // Map<String, dynamic> toJson() {
  //   return {
  //     'index': index,
  //     'data': data,
  //   };
  // }
}
