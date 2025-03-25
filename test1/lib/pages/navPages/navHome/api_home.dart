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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null && data['data']['locks'] is List) {
          return data['data']['locks'];
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

  // Updating or adding the lock configuration
  static Future<List<Map<String, dynamic>>> fetchLockConfigs(String userId, String espId, String color, String espName, bool favourite, String text) async {
    String apiUrl = 'https://capolavoro5ait.altervista.org/api.php?action=lockConfig'; // Ensure this endpoint is correct
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': userId, 'esp_id': espId, 'color': color, 'esp_name': espName, 'favourite': favourite, 'text': text},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null && data['data']['configs'] is List) {
          return List<Map<String, dynamic>>.from(data['data']['configs']);
        } else {
          debugPrint('No configurations found or invalid response structure');
        }
      } else {
        debugPrint('Failed to load lock configurations with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching lock configurations: $e');
    }
    return []; // Return an empty list if there's any issue
  }

}