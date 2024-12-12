import '../../model/rented_book_model.dart';
import 'api_services.dart';

class RentedBookService {
  final ApiService _apiService;
  RentedBookService(this._apiService);
  Future<List<RentedBook>> fetchRentedBooks(String userId) async {
    try {
      final response = await _apiService.get('rental/books', params: {'user_id': userId});
      final rentedBooks = (response as List).map((data) => RentedBook.fromJson(data)).toList();
      return rentedBooks;
    } catch (e) {
      throw Exception('Error fetching rented books: $e');
    }
  }
}
