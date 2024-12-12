class HistoryRentedBook {
  final String userId;
  final String isbnNo;
  final String title;
  final String author;
  final String coverImage;
  final String rentedDate;
  final String expiredDate;
  final String amountPaid;

  HistoryRentedBook({
    required this.userId,
    required this.isbnNo,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.rentedDate,
    required this.expiredDate,
    required this.amountPaid,
  });

  factory HistoryRentedBook.fromJson(Map<String, dynamic> json) {
    return HistoryRentedBook(
      userId: json['user_id'],
      isbnNo: json['isbn_no'],
      title: json['title'],
      author: json['author'],
      coverImage: json['cover_image'],
      rentedDate: json['rented_date'],
      expiredDate: json['expired_date'],
      amountPaid: json['price'],
    );
  }
}