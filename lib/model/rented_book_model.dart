class RentedBook {
  final int rentalId;
  final String userId;
  final String isbnNo;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final String bookFile;
  final String rentalDate;
  final String expiryDate;
  final String amountPaid;

  RentedBook({
    required this.rentalId,
    required this.userId,
    required this.isbnNo,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.bookFile,
    required this.rentalDate,
    required this.expiryDate,
    required this.amountPaid,
  });

  factory RentedBook.fromJson(Map<String, dynamic> json) {
    return RentedBook(
      rentalId: json['rental_id'],
      userId: json['user_id'],
      isbnNo: json['isbn_no'],
      title: json['title'],
      author: json['author'],
      coverImage: json['cover_image'],
      description: json['description'],
      bookFile: json['book_file'],
      rentalDate: json['rental_date'],
      expiryDate: json['expiry_date'],
      amountPaid: json['amount_paid'],
    );
  }
}