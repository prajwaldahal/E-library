import 'package:flutter/material.dart';
import '../../model/history_rented_model.dart';
import '../services/api_services.dart';
import '../services/history_rented_book_service.dart';
import '../services/secure_storage_helper.dart';

class HistoryRentedBooksProvider extends ChangeNotifier {
  final HistoryRentedBooksService _historyRentedBooksService =
  HistoryRentedBooksService(ApiService());

  List<HistoryRentedBook> _historyRentedBooks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HistoryRentedBook> get historyRentedBooks => _historyRentedBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHistoryRentedBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final uid = await SecureStorageHelper.read("uid");
      if (uid != null) {
        _historyRentedBooks = await _historyRentedBooksService.fetchHistoryRentedBooks(uid);
        _errorMessage = null;
      } else {
        _errorMessage = 'User ID is not available';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
