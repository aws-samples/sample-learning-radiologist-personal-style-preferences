import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

/// Badge showing preference category with appropriate color
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CategoryColorsTheme>()!.getColor(category);
    final displayName = _formatCategory(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 13,
            color: color.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 5),
          Text(
            displayName,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) {
    switch (category) {
      case 'terminology':
        return 'Terminology';
      case 'formatting':
        return 'Formatting';
      case 'detail_level':
        return 'Detail Level';
      case 'phrasing':
        return 'Phrasing';
      case 'priority':
        return 'Priority';
      default:
        return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'terminology':
        return Icons.spellcheck;
      case 'formatting':
        return Icons.format_list_bulleted;
      case 'detail_level':
        return Icons.tune;
      case 'phrasing':
        return Icons.text_format;
      case 'priority':
        return Icons.sort;
      default:
        return Icons.label_outline;
    }
  }
}
