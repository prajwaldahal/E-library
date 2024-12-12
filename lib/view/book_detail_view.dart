import 'package:elibrary/common/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../common/constants/api_constant.dart';
import '../common/styles/app_colors.dart';
import '../model/book_model.dart';
class BookDetailScreen extends StatelessWidget {
  final Book? book;
  const BookDetailScreen({
    super.key,
    this.book,
  });

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('No book details available.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cardBackgroundColor,
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: AppColors.primaryColorLight,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: book?.coverImage != null
                    ? Image.network(
                  "${Constants.imageURL}${book?.coverImage!}",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: AppColors.noBooksFoundTextColor,
                  ),
                )
                    : const Icon(
                  Icons.book,
                  size: 80,
                  color: AppColors.noBooksFoundTextColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                book!.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bookTitleColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                "by ${book?.author}",
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.bookSubtitleColor,
                ),
              ),
              const SizedBox(height: 20),
              RatingBarIndicator(
                rating: book!.avgRating,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: AppColors.ratingStarColor,
                ),
                itemCount: 5,
                itemSize: 30,
                direction: Axis.horizontal,
              ),
              const SizedBox(height: 20),
              Text(
                book!.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.bodyTextColorLight,
                ),
                textAlign: TextAlign.justify,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Text(
                "Rs. ${book?.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColorLight,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  DialogUtils.showDatePickerDialog(context,book!);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  "Rent Book",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (book?.category != null && book!.category.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category, size: 18, color: AppColors.secondaryTextColorLight),
                    const SizedBox(width: 5),
                    Text(
                      book!.category,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.secondaryTextColorLight,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
