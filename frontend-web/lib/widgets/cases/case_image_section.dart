import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/case.dart';

/// Section displaying X-ray images for the case
class CaseImageSection extends StatefulWidget {
  const CaseImageSection({super.key, required this.imageUrls});

  final List<CaseImageUrl> imageUrls;

  @override
  State<CaseImageSection> createState() => _CaseImageSectionState();
}

class _CaseImageSectionState extends State<CaseImageSection> {
  int _selectedIndex = 0;
  bool _usePlaceholder = false;

  /// Placeholder image served from web assets (same-origin, no CORS issues)
  static const String _placeholderUrl = 'assets/placeholder-xray.png';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedImage = widget.imageUrls[_selectedIndex];

    // Use placeholder if URL is empty or if we've fallen back
    final shouldUsePlaceholder = _usePlaceholder || selectedImage.url.isEmpty;
    final imageUrl = shouldUsePlaceholder ? _placeholderUrl : selectedImage.url;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Icon(Icons.image_outlined, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'X-Ray Image',
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (shouldUsePlaceholder) ...[
                        const SizedBox(width: 8),
                        Builder(builder: (context) {
                          final cs = Theme.of(context).colorScheme;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.tertiaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Placeholder',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onTertiaryContainer,
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                // View selector if multiple images
                if (widget.imageUrls.length > 1)
                  Flexible(
                    child: SegmentedButton<int>(
                      segments: widget.imageUrls
                          .asMap()
                          .entries
                          .map((e) => ButtonSegment(
                                value: e.key,
                                label: Text('Image ${e.key + 1}'),
                              ))
                          .toList(),
                      selected: {_selectedIndex},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _selectedIndex = selection.first;
                          _usePlaceholder = false; // Reset placeholder on view change
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          // Image
          Container(
            height: 400,
            width: double.infinity,
            color: Colors.black,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // If network image fails, fall back to placeholder
                if (!_usePlaceholder && selectedImage.url.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => _usePlaceholder = true);
                    }
                  });
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                // Even placeholder failed
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
