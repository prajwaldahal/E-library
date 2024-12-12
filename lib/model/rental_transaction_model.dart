class RentalTransactionModel {
  final int id;
  final String isbnNo;
  final String rentalDate;
  final String expiryDate;
  final double amountPaid;
  final String filename;

  RentalTransactionModel({
    required this.id,
    required this.isbnNo,
    required this.rentalDate,
    required this.expiryDate,
    required this.amountPaid,
    required this.filename,
  });

  Map<String, dynamic> toMap() {
    return {
      'isbn_no': isbnNo,
      'rental_date': rentalDate,
      'expiry_date': expiryDate,
      'amount_paid': amountPaid,
      'filename': filename,
    };
  }

  factory RentalTransactionModel.fromMap(Map<String, dynamic> map) {
    return RentalTransactionModel(
      id: map['id'],
      isbnNo: map['isbn_no'],
      rentalDate: map['rental_date'],
      expiryDate: map['expiry_date'],
      amountPaid: map['amount_paid'],
      filename: map['filename'],
    );
  }
}
