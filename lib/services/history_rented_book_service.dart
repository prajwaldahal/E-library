import '../../model/history_rented_model.dart';
import 'api_services.dart';

class HistoryRentedBooksService {
  final ApiService _apiService;

  HistoryRentedBooksService(this._apiService);

  Future<List<HistoryRentedBook>> fetchHistoryRentedBooks(String userId) async {
    try {
      final response = await _apiService.get('rental/history', params: {'user_id': userId});

      return (response as List)
          .map((data) => HistoryRentedBook.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Error fetching rental history: $e');
    }
  }
}
