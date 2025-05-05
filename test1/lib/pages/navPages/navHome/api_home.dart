import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Fetching the list of locks and their configuration
  static Future<List<dynamic>> fetchLocks(String username, String password) async {
    String apiUrl = 'https://capolavoro5ait.altervista.org/api.php?action=getUserLocks';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username, 'password': password},
      );
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null && data['data']['locks'] is List) {
          return List<Map<String, dynamic>>.from(data['data']['locks']);
        } else {
          debugPrint('No locks found or invalid response structure');
        }
      } else {
        debugPrint('Failed to load locks with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching locks: $e');
    }
    return []; // Return an empty list if there's any issue
  }

static Future<void> updateLockConfig(Map<String, dynamic> lock) async {
  String apiUrl = 'https://capolavoro5ait.altervista.org/api.php?action=lockConfig';
  

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'user_id': lock['user_id'].toString(),
        'esp_id': lock['lock_id'].toString(),
        'color': lock['color'] ?? '',
        'favourite': (lock['favourites'] ?? 0).toString(),
        'text': lock['text'] ?? '',
        'esp_name': lock['name'] ?? '',
      },
    );

    debugPrint("aggiornato");
    debugPrint(lock['favourites'].toString());


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'success') {
        debugPrint('Configurazione aggiornata con successo');
      } else {
        debugPrint('Failed to update lock configuration: ${data['message']}');
      }
    } else {
      debugPrint('Failed to update lock configuration with status: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error updating lock configuration: $e');
  }
}
}
