import 'package:flutter/material.dart';
import '../model/book_model.dart';
import '../model/category_model.dart';
import '../services/category_service.dart';
import '../services/search_service.dart';
class SearchProvider extends ChangeNotifier {
  final SearchService _searchService = SearchService();
  final CategoryService _categoryService = CategoryService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  String _selectedCategoryId = '';
  String get selectedCategoryId => _selectedCategoryId;

  double _minRating = 3.5;
  double get minRating => _minRating;

  double _maxPrice = 100.0;
  double get maxPrice => _maxPrice;

  bool _isAscending = true;
  bool get isAscending => _isAscending;

  List<Book> books = [];

  void setSelectedCategory(String value) {
    _selectedCategoryId = value == 'all' ? '' : value;
    notifyListeners();
  }

  void setMinRating(double value) {
    _minRating = value;
    notifyListeners();
  }

  void setMaxPrice(double value) {
    _maxPrice = value;
    notifyListeners();
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    sortBooksByPrice();
    notifyListeners();
  }

  void sortBooksByPrice() {
    books = mergeSort(books, ascending: _isAscending);
    notifyListeners();
  }

  List<Book> mergeSort(List<Book> books, {required bool ascending}) {
    if (books.length <= 1) return books;

    int mid = books.length ~/ 2;
    List<Book> left = mergeSort(books.sublist(0, mid), ascending: ascending);
    List<Book> right = mergeSort(books.sublist(mid), ascending: ascending);

    return merge(left, right, ascending);
  }

  List<Book> merge(List<Book> left, List<Book> right, bool ascending) {
    int i = 0, j = 0;
    List<Book> merged = [];

    while (i < left.length && j < right.length) {
      if ((ascending && left[i].price <= right[j].price) ||
          (!ascending && left[i].price > right[j].price)) {
        merged.add(left[i++]);
      } else {
        merged.add(right[j++]);
      }
    }

    merged.addAll(left.sublist(i));
    merged.addAll(right.sublist(j));

    return merged;
  }

  Future<void> loadCategories() async {
    _categories = await _categoryService.fetchCategories();
    notifyListeners();
  }

  Future<void> searchBooks(String query) async {
    _isLoading = true;
    notifyListeners();

    books = await _searchService.searchBooks(
      query: query,
      categoryId: _selectedCategoryId,
      minRating: _minRating,
      maxPrice: _maxPrice,
    );

    sortBooksByPrice();
    _isLoading = false;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategoryId = '';
    _minRating = 3.5;
    _maxPrice = 100.0;
    searchBooks('');
  }
}
