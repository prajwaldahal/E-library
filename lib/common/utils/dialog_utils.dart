import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/book_model.dart';
import '../../providers/rent_provider.dart';
import '../../services/khalti_payment_service.dart';
import '../widgets/rentdate_picker_dialog.dart';
class DialogUtils {
  static void showDatePickerDialog(BuildContext context, Book book) async {
    final rentProvider = Provider.of<RentProvider>(context, listen: false);
    final khaltiPaymentService = KhaltiPaymentService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: rentProvider,
          child: Consumer<RentProvider>(
            builder: (context, provider, child) {
              return RentDatePickerDialog(
                book: book,
                rentProvider: provider,
                khaltiPaymentService: khaltiPaymentService,
              );
            },
          ),
        );
      },
    );
  }
}
