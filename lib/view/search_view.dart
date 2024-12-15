import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/constants/api_constant.dart';
import '../common/styles/app_colors.dart';
import '../providers/search_provider.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Books'),
        centerTitle: true,
        backgroundColor: AppColors.primaryColorLight,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: ChangeNotifierProvider(
          create: (_) => SearchProvider()..loadCategories(),
          child: Consumer<SearchProvider>(builder: (context, viewModel, child) {
            return Column(
              children: [
                _buildSearchBar(viewModel),
                const SizedBox(height: 15),
                _buildFilterOptions(viewModel),
                const SizedBox(height: 15),
                _buildSortButton(viewModel),
                const SizedBox(height: 10),
                Expanded(child: _buildBookList(viewModel, context)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSearchBar(SearchProvider viewModel) {
    return TextField(
      onChanged: (query) {
        viewModel.searchBooks(query);
      },
      decoration: InputDecoration(
        labelText: 'Search books by title, author, or ISBN',
        prefixIcon: const Icon(Icons.search, color: AppColors.primaryColorLight),
        filled: true,
        fillColor: AppColors.searchBarFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.searchBarBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primaryColorLight, width: 2),
        ),
      ),
    );
  }

  Widget _buildFilterOptions(SearchProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryDropdown(viewModel),
        const SizedBox(height: 10),
        _buildRatingSlider(viewModel),
        const SizedBox(height: 10),
        _buildPriceSlider(viewModel),
      ],
    );
  }

  Widget _buildSortButton(SearchProvider viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Sort by Price:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            viewModel.isAscending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: AppColors.primaryColorLight,
          ),
          onPressed: viewModel.toggleSortOrder,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(SearchProvider viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedCategoryId.isEmpty ? null : viewModel.selectedCategoryId,
      hint: const Text("Select Category"),
      onChanged: (value) {
        viewModel.setSelectedCategory(value ?? '');
        viewModel.searchBooks('');
      },
      items: [
        const DropdownMenuItem<String>(
          value: 'all',
          child: Text('All Categories'),
        ),
        ...viewModel.categories.map((category) {
          return DropdownMenuItem<String>(
            value: category.id.toString(),
            child: Text(category.name),
          );
        }),
      ],
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: AppColors.searchBarFillColor,
      ),
    );
  }

  Widget _buildRatingSlider(SearchProvider viewModel) {
    return Row(
      children: [
        const Text('Min Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Slider(
            value: viewModel.minRating,
            min: 0,
            max: 5,
            divisions: 10,
            label: '${viewModel.minRating} Stars',
            activeColor: AppColors.primaryColorLight,
            inactiveColor: AppColors.primaryColorLight.withOpacity(0.3),
            onChanged: (value) {
              viewModel.setMinRating(value);
              viewModel.searchBooks('');
            },
          ),
        ),
        Text(
          '${viewModel.minRating}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPriceSlider(SearchProvider viewModel) {
    return Row(
      children: [
        const Text('Max Price:', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Slider(
            value: viewModel.maxPrice,
            min: 0,
            max: 5000,
            divisions: 2500,
            activeColor: AppColors.primaryColorLight,
            inactiveColor: AppColors.primaryColorLight.withOpacity(0.3),
            onChanged: (value) {
              viewModel.setMaxPrice(value.toDouble());
              viewModel.searchBooks('');
            },
          ),
        ),
        Text(
          'Rs.${viewModel.maxPrice.truncateToDouble()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBookList(SearchProvider viewModel, BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColorLight),
      );
    }

    if (viewModel.books.isEmpty) {
      return const Center(
        child: Text(
          "No books found.",
          style: TextStyle(fontSize: 16, color: AppColors.noBooksFoundTextColor),
        ),
      );
    }

    int columns = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: viewModel.books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (context, index) {
        final book = viewModel.books[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              '/book-detail',
              arguments: book,
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: AppColors.cardShadowColor,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: book.coverImage != null
                        ? Image.network(
                      "${Constants.imageURL}${book.coverImage!}",
                      width: double.infinity,
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bookTitleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.bookSubtitleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rs.${book.price.toStringAsFixed(2)}/mth",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bookPriceColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                Text(
                                  "${book.avgRating}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


