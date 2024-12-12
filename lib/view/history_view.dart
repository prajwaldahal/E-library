import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/api_constant.dart';
import '../providers/history_book_provider.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental History'),
      ),
      body: Consumer<HistoryRentedBooksProvider>(
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
          } else if (provider.historyRentedBooks.isEmpty) {
            return const Center(child: Text('No rental history available.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.historyRentedBooks.length,
              itemBuilder: (context, index) {
                final rentedBook = provider.historyRentedBooks[index];

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
                        Text('Rental Period: ${rentedBook.rentedDate} - ${rentedBook.expiredDate}'),
                        const SizedBox(height: 4),
                      ],
                    ),
                    trailing: Text(
                      'RS.${rentedBook.amountPaid}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<HistoryRentedBooksProvider>(context, listen: false).fetchHistoryRentedBooks();
        },
        tooltip: 'Refresh Rental History',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
