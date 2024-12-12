import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/book_model.dart';
import '../../providers/rent_provider.dart';
import '../../services/khalti_payment_service.dart';
class RentDatePickerDialog extends StatelessWidget {
  final Book book;
  final RentProvider rentProvider;
  final KhaltiPaymentService khaltiPaymentService;

  const RentDatePickerDialog({
    super.key,
    required this.book,
    required this.rentProvider,
    required this.khaltiPaymentService,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select a Date',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  Text(
                    "${rentProvider.selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(const Duration(days: 366)),
                  onDateTimeChanged: (DateTime newDateTime) {
                    rentProvider.updateDate(newDateTime, book.price);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Rs. ${rentProvider.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (rentProvider.price > 10)
                ElevatedButton(
                  onPressed: () async {
                    try {
                      khaltiPaymentService.payWithKhalti(
                        expiryDate: rentProvider.selectedDate,
                        context: context,
                        amount: (rentProvider.price * 100).toInt(),
                        bookName: book.title,
                        bookId: book.isbnNo,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error initiating payment: $e')),
                      );
                      debugPrint("Error: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Pay with Khalti',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
