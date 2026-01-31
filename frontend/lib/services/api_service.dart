import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = "http://127.0.0.1:8000"}) {
    print("ApiService CREATED, baseUrl = $baseUrl");
  }

  // ------------------ Méthodes POST génériques ------------------

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      }

      // Gestion des erreurs 404, 409, 422
      if ([404, 409, 422].contains(response.statusCode)) {
        final body = jsonDecode(response.body);
        String message = "Erreur";

        if (body["detail"] != null) {
          if (body["detail"] is String) {
            message = body["detail"];
          } else if (body["detail"] is List && body["detail"].isNotEmpty) {
            // On concatène tous les messages pour Pydantic
            message = body["detail"].map((e) => e["msg"]).join("\n");
          }
        }

        return {"success": false, "message": message};
      }

      return {
        "success": false,
        "message": "Erreur inattendue (${response.statusCode})",
      };
    } catch (e) {
      return {"success": false, "message": "Erreur réseau: $e"};
    }
  }

  Future<Map<String, dynamic>> _postVoid(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return {"success": true};
      }

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      String message = "Erreur";

      if (body["detail"] != null) {
        if (body["detail"] is String) {
          message = body["detail"];
        } else if (body["detail"] is List && body["detail"].isNotEmpty) {
          message = body["detail"].map((e) => e["msg"]).join("\n");
        }
      }

      return {"success": false, "message": message};
    } catch (e) {
      return {"success": false, "message": "Erreur réseau: $e"};
    }
  }

  // ------------------ Création d'objets ------------------

  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> data) =>
      _post('articles/', data);
  Future<Map<String, dynamic>> createExperience(Map<String, dynamic> data) =>
      _post('experiences/', data);
  Future<Map<String, dynamic>> createMachine(Map<String, dynamic> data) =>
      _post('machines/', data);
  Future<Map<String, dynamic>> createPhantom(Map<String, dynamic> data) =>
      _post('phantoms/', data);
  Future<Map<String, dynamic>> createDetector(Map<String, dynamic> data) =>
      _post('detectors/', data);

  // ------------------ Association avec une expérience ------------------

  Future<Map<String, dynamic>> addMachineToExperience(
    int experimentId,
    Map<String, dynamic> data,
  ) => _postVoid('experiences/$experimentId/machines', data);

  Future<Map<String, dynamic>> addPhantomToExperience(
    int experimentId,
    int phantomId,
  ) => _postVoid('experiences/$experimentId/phantoms', {
    "phantom_id": phantomId,
  });

  Future<Map<String, dynamic>> addDetectorToExperience(
    int experimentId,
    Map<String, dynamic> data,
  ) => _postVoid('experiences/$experimentId/detectors', data);

  // ------------------ Upload de fichiers ------------------

  Future<Map<String, dynamic>> uploadDonnee({
    required int experimentId,
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
    String? unit,
    String? description,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/donnees/upload/$experimentId');
      final request = http.MultipartRequest('POST', uri);

      request.fields['data_type'] = dataType;
      if (unit != null) request.fields['unit'] = unit;
      if (description != null) request.fields['description'] = description;

      request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
      );

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201) {
        return {"success": true};
      } else {
        String message = "Erreur upload (${streamedResponse.statusCode})";
        try {
          final body = jsonDecode(responseBody);
          if (body["detail"] != null) {
            if (body["detail"] is String) {
              message += " : ${body["detail"]}";
            } else if (body["detail"] is List && body["detail"].isNotEmpty) {
              message += " : ${body["detail"].map((e) => e["msg"]).join("\n")}";
            }
          }
        } catch (_) {}
        return {"success": false, "message": message};
      }
    } catch (e) {
      return {"success": false, "message": "Erreur réseau: $e"};
    }
  }

  // ------------------ Résumé de l'expérience ------------------

  Future<Map<String, dynamic>> getExperimentSummary(int experimentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/experiences/$experimentId/summary'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return {"success": false, "message": "Impossible de récupérer le résumé"};
    } catch (e) {
      return {"success": false, "message": "Erreur réseau: $e"};
    }
  }
}
