import 'package:elibrary/services/api_services.dart';
import 'package:flutter/material.dart';

import '../../services/secure_storage_helper.dart';
import '../../model/rented_book_model.dart';
import '../services/rent_book_services.dart';

class RentedBooksProvider extends ChangeNotifier {
  final RentedBookService _rentedBookService=RentedBookService(ApiService());
  List<RentedBook> _rentedBooks = [];
  bool _isLoading = false;
  String? _errorMessage;


  List<RentedBook> get rentedBooks => _rentedBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRentedBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final uid = await SecureStorageHelper.read("uid");
      if (uid != null) {
        _rentedBooks = await _rentedBookService.fetchRentedBooks(uid);
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
