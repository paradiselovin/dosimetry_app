import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  ApiService() {
    print("ApiService CREATED, baseUrl = $baseUrl");
  }

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

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      return {"success": false, "message": body["detail"][0]["msg"]};
    }

    return {
      "success": false,
      "message": "Unexpected error (${response.statusCode})",
    };
  }

  Future<Map<String, dynamic>> createExperience(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/experiences/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    }

    if (response.statusCode == 409) {
      return {"success": false, "message": jsonDecode(response.body)["detail"]};
    }

    if (response.statusCode == 404) {
      return {"success": false, "message": jsonDecode(response.body)["detail"]};
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      return {"success": false, "message": body["detail"][0]["msg"]};
    }

    return {
      "success": false,
      "message": "Unexpected error (${response.statusCode})",
    };
  }

  Future<Map<String, dynamic>> createMachine(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/machines/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    }

    if (response.statusCode == 409) {
      return {"success": false, "message": jsonDecode(response.body)["detail"]};
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      return {"success": false, "message": body["detail"][0]["msg"]};
    }

    return {
      "success": false,
      "message": "Unexpected error (${response.statusCode})",
    };
  }

  Future<void> addMachineToExperience(
    int experimentId,
    Map<String, dynamic> data,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/experiences/$experimentId/machines'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  Future<Map<String, dynamic>> createPhantom(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phantoms/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    }

    if (response.statusCode == 409) {
      return {"success": false, "message": jsonDecode(response.body)["detail"]};
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      return {"success": false, "message": body["detail"][0]["msg"]};
    }

    return {
      "success": false,
      "message": "Unexpected error (${response.statusCode})",
    };
  }

  Future<void> addPhantomToExperience(int experimentId, int phantomId) async {
    await http.post(
      Uri.parse('$baseUrl/experiences/$experimentId/phantoms'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phantom_id": phantomId}),
    );
  }

  Future<Map<String, dynamic>> createDetector(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detectors/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    }

    if (response.statusCode == 409) {
      return {"success": false, "message": jsonDecode(response.body)["detail"]};
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      return {"success": false, "message": body["detail"][0]["msg"]};
    }

    return {
      "success": false,
      "message": "Unexpected error (${response.statusCode})",
    };
  }

  Future<void> addDetectorToExperience(
    int experimentId,
    Map<String, dynamic> data,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/experiences/$experimentId/detectors'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  Future<void> uploadDonnee({
    required int experimentId,
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
    String? unit,
    String? description,
  }) async {
    final uri = Uri.parse('$baseUrl/donnees/upload/$experimentId');

    final request = http.MultipartRequest('POST', uri);
    request.fields['data_type'] = dataType;
    if (unit != null) request.fields['unit'] = unit;
    if (description != null) request.fields['description'] = description;

    request.files.add(
      http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
    );

    final response = await request.send();

    if (response.statusCode != 201) {
      final body = await response.stream.bytesToString();
      throw Exception('Erreur upload (${response.statusCode}) : $body');
    }
  }
}
