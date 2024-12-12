import 'package:flutter/material.dart';

import '../../common/utils/rent_helper.dart';

class RentProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  double _price = 0;

  DateTime get selectedDate => _selectedDate;
  double get price => _price;

  void updateDate(DateTime newDate, double bookPrice) {
    _selectedDate = newDate;
    _price = RentHelper.calculatePrice(newDate, bookPrice);
    notifyListeners();
  }
}
