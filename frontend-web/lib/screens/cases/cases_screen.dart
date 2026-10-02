import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cases_provider.dart';
import '../../providers/local_storage_provider.dart';
import '../../widgets/common/floating_icon.dart';
import 'case_detail_view.dart';
import 'case_list_view.dart';

/// Cases screen with split view (list + detail)
class CasesScreen extends ConsumerStatefulWidget {
  const CasesScreen({super.key, this.initialCaseId});

  final String? initialCaseId;

  @override
  ConsumerState<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends ConsumerState<CasesScreen> {
  static const double _minWidth = 240;
  static const double _maxWidth = 500;
  static const double _defaultWidth = 320;

  double _sidebarWidth = _defaultWidth;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCaseId != null) {
      Future.microtask(() {
        ref.read(selectedCaseIdProvider.notifier).state = widget.initialCaseId;
      });
    }
    // Load persisted sidebar width
    final prefs = ref.read(sharedPreferencesProvider);
    _sidebarWidth = prefs.getDouble(kCaseSidebarWidthKey) ?? _defaultWidth;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCaseId = ref.watch(selectedCaseIdProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Case list sidebar
        SizedBox(
          width: _sidebarWidth,
          child: const CaseListView(),
        ),
        // Draggable divider
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            onHorizontalDragStart: (_) {
              setState(() => _isDragging = true);
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                _sidebarWidth = (_sidebarWidth + details.delta.dx)
                    .clamp(_minWidth, _maxWidth);
              });
            },
            onHorizontalDragEnd: (_) {
              setState(() => _isDragging = false);
              ref
                  .read(sharedPreferencesProvider)
                  .setDouble(kCaseSidebarWidthKey, _sidebarWidth);
            },
            child: Container(
              width: 8,
              color: _isDragging
                  ? colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              child: Center(
                child: Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _isDragging
                        ? colorScheme.primary.withValues(alpha: 0.5)
                        : colorScheme.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Case detail
        Expanded(
          child: selectedCaseId != null
              ? CaseDetailView(caseId: selectedCaseId)
              : _EmptyState(
                  firstNewCaseId: ref
                      .watch(casesProvider)
                      .valueOrNull
                      ?.where((c) => !c.hasGenerated)
                      .map((c) => c.caseId)
                      .firstOrNull,
                ),
        ),
      ],
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState({this.firstNewCaseId});

  final String? firstNewCaseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingIcon(
              icon: Icons.folder_open_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Ready to get started?',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a case from the list, then generate an AI impression from the findings.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tip: Press Ctrl+G to generate after selecting a case.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            if (firstNewCaseId != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () {
                  ref.read(selectedCaseIdProvider.notifier).state =
                      firstNewCaseId;
                },
                child: const Text('Start with first new case →'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
