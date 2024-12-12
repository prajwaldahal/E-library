import 'dart:convert';
import 'package:elibrary/common/constants/api_constant.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class ApiService {
  final String _baseUrl = Constants.baseApiServer;

  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    try {
      Uri uri = Uri.parse('$_baseUrl/$endpoint');
      if (params != null) {
        uri = uri.replace(queryParameters: params);
      }
      final response = await http.get(uri);
      debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send data');
      }
    } catch (e) {
      throw Exception('Error sending data: $e');
    }
  }
}
