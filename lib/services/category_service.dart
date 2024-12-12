import '../model/category_model.dart';
import 'api_services.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  Future<List<Category>> fetchCategories() async {
    final response = await _apiService.get('categories');
    if (response != null) {
      return List<Category>.from(response.map((category) => Category.fromJson(category)));
    } else {
      return [];
    }
  }
}
