import 'package:flutter/material.dart';
import '../providers/books_provider.dart';

/// Active filter badge widget
class ActiveFilterBadge extends StatelessWidget {
  final BooksProvider provider;
  final int bookCount;

  const ActiveFilterBadge({
    super.key,
    required this.provider,
    required this.bookCount,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.currentFilter == 'None') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt, size: 16, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Text(
                  provider.currentFilter,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    provider.setFilter('None');
                  },
                  child: Icon(Icons.close, size: 16, color: Colors.blue[700]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$bookCount ${bookCount == 1 ? 'book' : 'books'}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for sort and filter options
class FilterSortBottomSheet extends StatefulWidget {
  final BooksProvider provider;
  final VoidCallback onUpdate;

  const FilterSortBottomSheet({
    super.key,
    required this.provider,
    required this.onUpdate,
  });

  @override
  State<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends State<FilterSortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 16, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.sort, color: Colors.grey[700]),
                const SizedBox(width: 12),
                const Text(
                  'Sort & Filter',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SORT BY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SortOption(
                    title: 'Recently Added',
                    icon: Icons.schedule_rounded,
                    isSelected: widget.provider.sortOption == 'Recently Added',
                    onTap: () {
                      widget.provider.setSortOption('Recently Added');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  SortOption(
                    title: 'Title',
                    icon: Icons.title_rounded,
                    isSelected: widget.provider.sortOption == 'Title',
                    onTap: () {
                      widget.provider.setSortOption('Title');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  SortOption(
                    title: 'Author',
                    icon: Icons.person_rounded,
                    isSelected: widget.provider.sortOption == 'Author',
                    onTap: () {
                      widget.provider.setSortOption('Author');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'FILTER BY STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilterOption(
                    title: 'All Books',
                    icon: Icons.library_books_rounded,
                    iconColor: Colors.grey[700]!,
                    isSelected: widget.provider.currentFilter == 'None',
                    onTap: () {
                      widget.provider.setFilter('None');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  FilterOption(
                    title: 'Favourites',
                    icon: Icons.favorite_rounded,
                    iconColor: Colors.red,
                    isSelected: widget.provider.currentFilter == 'Favourites',
                    onTap: () {
                      widget.provider.setFilter('Favourites');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  FilterOption(
                    title: 'Currently Reading',
                    icon: Icons.menu_book_rounded,
                    iconColor: Colors.blue,
                    isSelected: widget.provider.currentFilter == 'Reading',
                    onTap: () {
                      widget.provider.setFilter('Reading');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  FilterOption(
                    title: 'To Read',
                    icon: Icons.bookmark_rounded,
                    iconColor: Colors.orange,
                    isSelected: widget.provider.currentFilter == 'To Read',
                    onTap: () {
                      widget.provider.setFilter('To Read');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  FilterOption(
                    title: 'Read',
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.green,
                    isSelected: widget.provider.currentFilter == 'Read',
                    onTap: () {
                      widget.provider.setFilter('Read');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  FilterOption(
                    title: 'Unread',
                    icon: Icons.radio_button_unchecked_rounded,
                    iconColor: Colors.grey,
                    isSelected: widget.provider.currentFilter == 'Unread',
                    onTap: () {
                      widget.provider.setFilter('Unread');
                      setState(() {});
                      widget.onUpdate();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual sort option widget
class SortOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SortOption({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue[700] : Colors.grey[800],
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.blue[700],
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

/// Individual filter option widget
class FilterOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue[700] : Colors.grey[800],
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.blue[700],
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
