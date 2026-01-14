import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/articles/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    }

    if (response.statusCode == 409) {
      return {"success": false, "message": jsonDecode(response.body)["detail"]};
    }

    return {
      "success": false,
      "message": "Unexpected error (${response.statusCode})",
    };
  }
}
