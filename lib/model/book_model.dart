class Book {
  String isbnNo;
  String title;
  String author;
  String description;
  String category;
  double price;
  String? coverImage;
  double avgRating;

  Book({
    required this.isbnNo,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.price,
    required this.coverImage,
    required this.avgRating,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      isbnNo: json['isbn_no'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      category: json['category_name'],
      price: double.tryParse(json['price']) ?? 0.0,
      coverImage: json['cover_image'] ?? '',
      avgRating: double.tryParse(json['avg_rating']) ?? 0.0,
    );
  }
}
