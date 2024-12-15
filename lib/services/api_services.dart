import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:elibrary/common/constants/api_constant.dart';
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

  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(endpoint.startsWith('http') ? endpoint : '$_baseUrl/$endpoint');
      final response = await http.post(
        uri,
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending data: $e');
    }
  }
}
