import 'package:elibrary/providers/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/constants/api_constant.dart';
import '../providers/rented_book_provider.dart';
import 'pdf_viewer_page.dart';


class RentedView extends StatelessWidget {
  const RentedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rented Books'),
      ),
      body: Consumer<RentedBooksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Error: ${provider.errorMessage}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (provider.rentedBooks.isEmpty) {
            return const Center(child: Text('No rented books available.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.rentedBooks.length,
              itemBuilder: (context, index) {
                final rentedBook = provider.rentedBooks[index];
                DateTime expiryDate = DateTime.parse(rentedBook.expiryDate);
                DateTime currentDate = DateTime.now();
                int remainingDays = expiryDate.difference(currentDate).inDays;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Image.network(
                      "${Constants.imageURL}${rentedBook.coverImage}",
                      width: 50,
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      rentedBook.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rentedBook.author),
                        const SizedBox(height: 4),
                        Text(
                          'Rental Period: ${rentedBook.rentalDate} - ${rentedBook.expiryDate}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RS.${rentedBook.amountPaid}',
                          style:
                          const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const SizedBox(height: 4),
                        remainingDays > 0
                            ? Text(
                          'Due in: $remainingDays days',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.red),
                        )
                            : const Text(
                          'Expired',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      _openPDF(context, rentedBook.bookFile);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<RentedBooksProvider>(context, listen: false).fetchRentedBooks();
        },
        tooltip: 'Refresh Rented Books',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _openPDF(BuildContext context, String fileName) {
    final url = "${Constants.fileURL}$fileName";
    final pdfProvider = Provider.of<PDFProvider>(context, listen: false);
    pdfProvider.downloadAndStorePDF(url).then((_) {
      if (pdfProvider.errorMessage == null) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => const PDFViewerPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pdfProvider.errorMessage!)),
        );
      }
    });
  }
}
