import 'package:flutter/foundation.dart';

import '../model/book_model.dart';
import 'api_services.dart';

class SearchService {
  final ApiService _apiService = ApiService();

  Future<List<Book>> searchBooks({
    required String query,
    required String categoryId,
    required double minRating,
    required double maxPrice,
  }) async {
    try {
      final response = await _apiService.get('books/search', params: {
        'query': query,
        'categoryId': categoryId,
        'minRating': minRating.toString(),
        'maxPrice': maxPrice.toString(),
      });

      if (response is List) {
        return response.map((book) => Book.fromJson(book)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching search results: $e');
      return [];
    }
  }
}
