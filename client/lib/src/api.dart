import 'dart:convert';
import 'package:http/http.dart' as http;

class EmploysApi {
  Future<List> getEmploys() async {
    final response = await http.get(Uri.http('localhost:8081', ''));
    final jsonData = jsonDecode(response.body);

    print(jsonData['employees']);
    return jsonData['employees'];
  }
}
