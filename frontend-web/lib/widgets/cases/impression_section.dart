import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/api_models.dart';
import '../../models/case.dart';
import '../../services/api_service.dart';
import '../../utils/formatters.dart';
import '../common/floating_icon.dart';
import '../common/progress_stepper.dart';
import 'history_timeline_entry.dart';
import 'pulsing_generate_button.dart';

/// Section card for displaying generated impression and editing
class ImpressionSection extends StatefulWidget {
  const ImpressionSection({
    super.key,
    required this.caseDetail,
    required this.generatedImpression,
    required this.baseImpression,
    required this.preferencesApplied,
    required this.preferencesUsed,
    required this.baseImpressionModel,
    required this.refinementModel,
    this.generationTrace,
    required this.editController,
    required this.isGenerating,
    required this.isSaving,
    required this.generationPhase,
    required this.savePhase,
    required this.onGenerate,
    required this.onSave,
    required this.canSave,
  });

  final CaseDetail caseDetail;
  final String? generatedImpression;
  final String? baseImpression;
  final List<AppliedPreference> preferencesApplied;
  final int preferencesUsed;
  final String? baseImpressionModel;
  final String? refinementModel;
  final GenerationTrace? generationTrace;
  final TextEditingController editController;
  final bool isGenerating;
  final bool isSaving;
  final GenerationPhase generationPhase;
  final SavePhase savePhase;
  final VoidCallback onGenerate;
  final VoidCallback onSave;
  final bool canSave;

  @override
  State<ImpressionSection> createState() => _ImpressionSectionState();
}

class _ImpressionSectionState extends State<ImpressionSection> {
  bool _showReferenceImpression = false;
  bool _showBaseImpression = false;
  bool _showHistory = false;

  /// Model attribution text (e.g. "Claude Sonnet 4.5")
  String? get _modelAttribution {
    final baseModel = widget.baseImpressionModel ?? widget.caseDetail.baseImpressionModel;
    if (baseModel == null) return null;
    final baseName = formatModelName(baseModel);
    final refModel = widget.refinementModel ?? widget.caseDetail.refinementModel;
    if (refModel != null) {
      final refName = formatModelName(refModel);
      if (refName != baseName) return '$baseName + $refName';
    }
    return baseName;
  }

  /// Check if the impression has been modified from original
  bool get _isModified {
    final original = widget.generatedImpression ?? widget.caseDetail.currentImpression;
    return original != null && widget.editController.text != original;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImpression = widget.generatedImpression != null ||
        widget.caseDetail.generatedImpression != null;

    // Determine if we have base/reference impressions to show
    final hasBaseImpression = widget.baseImpression != null ||
        widget.caseDetail.baseImpression != null;
    final hasReferenceImpression = widget.caseDetail.referenceImpression != null;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.sectionHeaderDecoration(colorScheme),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Generated Impression',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Toggle buttons - icon only on small screens
                if (hasReferenceImpression)
                  IconButton(
                    icon: Icon(
                      _showReferenceImpression ? Icons.visibility : Icons.visibility_outlined,
                      size: 18,
                    ),
                    tooltip: 'Reference Impression',
                    onPressed: () => setState(() => _showReferenceImpression = !_showReferenceImpression),
                    style: IconButton.styleFrom(
                      foregroundColor: _showReferenceImpression
                          ? colorScheme.primary
                          : colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(32, 32),
                    ),
                  ),
                if (hasBaseImpression)
                  IconButton(
                    icon: Icon(
                      _showBaseImpression ? Icons.layers : Icons.layers_outlined,
                      size: 18,
                    ),
                    tooltip: 'Base Impression',
                    onPressed: () => setState(() => _showBaseImpression = !_showBaseImpression),
                    style: IconButton.styleFrom(
                      foregroundColor: _showBaseImpression
                          ? colorScheme.primary
                          : colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(32, 32),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reference impression (inline toggle)
                if (_showReferenceImpression && hasReferenceImpression) ...[
                  _buildInlineImpression(
                    context,
                    label: 'Reference Impression (Ground Truth)',
                    text: widget.caseDetail.referenceImpression!,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                ],

                // Base impression (inline toggle)
                if (_showBaseImpression && hasBaseImpression) ...[
                  _buildInlineImpression(
                    context,
                    label: widget.preferencesUsed > 0
                        ? 'Base Impression (Before Preferences)'
                        : 'Base Impression (No Preferences Applied)',
                    text: widget.baseImpression ?? widget.caseDetail.baseImpression ?? '',
                    color: widget.preferencesUsed > 0 ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                ],

                // Show progress or editor
                if (widget.isGenerating)
                  _buildGenerationProgress(context)
                else if (widget.isSaving)
                  _buildSaveProgress(context)
                else if (!hasImpression)
                  _buildEmptyState(context)
                else ...[
                  // Impression editor
                  TextField(
                    controller: widget.editController,
                    maxLines: null,
                    minLines: 4,
                    style: Theme.of(context).extension<ClinicalTextTheme>()?.editorStyle,
                    decoration: const InputDecoration(
                      hintText: 'Edit the impression...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Model attribution
                  if (_modelAttribution != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.smart_toy_outlined,
                            size: 13,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _modelAttribution!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Edit indicator (if modified)
                  if (_isModified) ...[
                    _buildEditIndicator(context),
                    const SizedBox(height: 12),
                  ],

                  // AI Reasoning panel (trace data or fallback to simple preferences)
                  if (widget.generationTrace != null ||
                      widget.preferencesApplied.isNotEmpty) ...[
                    _buildAIReasoningPanel(context),
                    const SizedBox(height: 12),
                  ],
                ],

                // Action buttons
                _buildActionButtons(context),

                // Collapsible History section
                if (widget.caseDetail.editHistory != null &&
                    widget.caseDetail.editHistory!.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildHistoryToggle(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineImpression(
    BuildContext context, {
    required String label,
    required String text,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            text,
            style: Theme.of(context).extension<ClinicalTextTheme>()?.bodyStyle
                ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerationProgress(BuildContext context) {
    return ProgressStepper<GenerationPhase>(
      title: 'Generating Impression',
      currentPhase: widget.generationPhase,
      steps: const [
        ProgressStep(phase: GenerationPhase.starting, label: 'Starting...'),
        ProgressStep(phase: GenerationPhase.retrieving, label: 'Retrieving preferences...'),
        ProgressStep(phase: GenerationPhase.generating, label: 'Generating base impression...'),
        ProgressStep(phase: GenerationPhase.refining, label: 'Applying style refinements...'),
        ProgressStep(phase: GenerationPhase.finishing, label: 'Finishing...'),
      ],
    );
  }

  Widget _buildSaveProgress(BuildContext context) {
    return ProgressStepper<SavePhase>(
      title: 'Saving Edit',
      currentPhase: widget.savePhase,
      steps: const [
        ProgressStep(phase: SavePhase.saving, label: 'Saving edit...'),
        ProgressStep(phase: SavePhase.analyzing, label: 'Analyzing changes...'),
        ProgressStep(phase: SavePhase.extracting, label: 'Extracting preferences...'),
        ProgressStep(phase: SavePhase.validating, label: 'Validating preferences...'),
        ProgressStep(phase: SavePhase.finishing, label: 'Finishing...'),
      ],
    );
  }

  Widget _buildHistoryToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final editHistory = widget.caseDetail.editHistory!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _showHistory = !_showHistory),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  _showHistory ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.history,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit History (${editHistory.length})',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
        if (_showHistory) ...[
          const SizedBox(height: 12),
          _buildHistoryTimeline(context, editHistory),
        ],
      ],
    );
  }

  Widget _buildHistoryTimeline(BuildContext context, List<CaseEditHistoryEntry> editHistory) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: editHistory.asMap().entries.map((entry) {
          final index = entry.key;
          final historyEntry = entry.value;
          final isSignificant = historyEntry.editDistance > 0.05;
          final isLast = index == editHistory.length - 1;

          return HistoryTimelineEntry(
            number: index + 1,
            title: historyEntry.source == 'generation'
                ? 'AI Generated'
                : 'User Edit ${index + 1}',
            subtitle: formatTimestampWithTime(historyEntry.timestamp),
            content: historyEntry.editedImpression,
            color: historyEntry.source == 'generation'
                ? Colors.blue
                : (isSignificant ? Colors.green : Colors.orange),
            editDistance: historyEntry.editDistance,
            isSignificant: isSignificant,
            isLast: isLast,
            preferencesSnapshot: historyEntry.preferencesSnapshot,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            FloatingIcon(
              icon: Icons.auto_awesome_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No impression generated yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Click "Generate" to create an impression from findings',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditIndicator(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.edit_note,
          size: 16,
          color: Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          'Modified from original',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange,
              ),
        ),
      ],
    );
  }

  Widget _buildAIReasoningPanel(BuildContext context) {
    final trace = widget.generationTrace;

    // Fallback: no trace data, show simple preference list
    if (trace == null) {
      return _buildSimplePreferenceList(context);
    }

    final colorScheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: Icon(Icons.psychology, size: 20, color: colorScheme.primary),
      title: Text(
        'AI Reasoning',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      children: [
        // Step 1: Preference Retrieval
        if (trace.retrieval != null)
          _buildTraceStep(
            context,
            icon: Icons.search,
            color: Colors.blue,
            title: 'Preference Retrieval',
            subtitle: 'Retrieved ${trace.retrieval!.kReturned} of '
                '${trace.retrieval!.totalPreferences} preferences '
                '(k=${trace.retrieval!.kRequested})',
            child: trace.retrieval!.retrieved.isNotEmpty
                ? Column(
                    children: trace.retrieval!.retrieved.map((p) {
                      final pct = (p.similarityScore * 100).round();
                      final badgeColor = p.similarityScore > 0.8
                          ? Colors.green
                          : p.similarityScore >= 0.6
                              ? Colors.amber
                              : Colors.grey;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$pct%',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: badgeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.preferenceText,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (p.category != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  p.category!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : null,
          ),

        // Step 2: Base Generation
        _buildTraceStep(
          context,
          icon: Icons.article_outlined,
          color: Colors.teal,
          title: 'Base Generation',
          subtitle: trace.baseGenerationModel != null
              ? 'Model: ${formatModelName(trace.baseGenerationModel!)}'
              : 'Model: unknown',
        ),

        // Step 3: Style Refinement
        if (trace.refinement != null)
          _buildTraceStep(
            context,
            icon: Icons.brush_outlined,
            color: Colors.purple,
            title: 'Style Refinement',
            subtitle: trace.refinement!.wasApplied
                ? '${trace.refinement!.baseLength} \u2192 '
                    '${trace.refinement!.refinedLength} chars, '
                    '${(trace.refinement!.editDistance * 100).round()}% change'
                    '${trace.refinement!.modelId != null ? ' \u2022 ${formatModelName(trace.refinement!.modelId!)}' : ''}'
                : 'No preferences available \u2014 base impression used as-is',
          ),

        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildTraceStep(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(color: color, width: 3),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            if (child != null) ...[
              const SizedBox(height: 8),
              child,
            ],
          ],
        ),
      ),
    );
  }

  /// Fallback for older cached cases with no trace data
  Widget _buildSimplePreferenceList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        'Preferences Applied (${widget.preferencesApplied.length})',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      children: widget.preferencesApplied.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  p.preferenceText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        PulsingGenerateButton(
          onPressed: widget.onGenerate,
          isGenerating: widget.isGenerating,
          isSaving: widget.isSaving,
          hasImpression: widget.generatedImpression != null ||
              widget.caseDetail.generatedImpression != null,
          label: widget.isGenerating
              ? 'Generating...'
              : (widget.generatedImpression != null ||
                      widget.caseDetail.generatedImpression != null)
                  ? 'Regenerate'
                  : 'Generate',
        ),
        if (widget.generatedImpression != null ||
            widget.caseDetail.generatedImpression != null)
          Tooltip(
            message: widget.isSaving
                ? 'Save in progress...'
                : widget.isGenerating
                    ? 'Generation in progress...'
                    : !widget.canSave
                        ? 'Edit the impression text to enable saving'
                        : 'Save edit (Ctrl+S)',
            child: FilledButton.tonalIcon(
              onPressed: widget.canSave && !widget.isGenerating && !widget.isSaving ? widget.onSave : null,
              icon: widget.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(widget.isSaving ? 'Saving...' : 'Save Edit'),
            ),
          ),
      ],
    );
  }
}
