import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/pdf_service.dart';

class PDFProvider with ChangeNotifier {
  final PDFService _pdfService=PDFService();
  File? _secureFile;
  bool _isLoading = false;
  String? _errorMessage;

  File? get secureFile => _secureFile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> downloadAndStorePDF(String url) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _secureFile = await _pdfService.downloadAndStorePDF(url);
      if (_secureFile == null) {
        _errorMessage = 'Failed to store PDF';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
