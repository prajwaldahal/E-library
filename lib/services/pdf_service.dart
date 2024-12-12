import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PDFService {
  Future<File?> downloadAndStorePDF(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final uniqueFileName = const Uuid().v4();
        final filePath = '${directory.path}/$uniqueFileName.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception('Failed to download PDF (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error downloading or storing PDF: $e');
    }
  }
}
