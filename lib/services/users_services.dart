import 'dart:convert';

import 'package:http/http.dart' as http;

class UsersServices {
  Future getUsers() async {
    final url = Uri.parse('https://vlncy-60532467e5ae.herokuapp.com/users/');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        var data = jsonDecode(response.body);
        print(data);

        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
