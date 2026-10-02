import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/api_models.dart';
import '../../models/case.dart';
import '../../providers/api_provider.dart';
import '../../providers/cases_provider.dart';
import '../../providers/local_storage_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/api_service.dart';
import '../../config/api_constants.dart';
import '../../utils/error_messages.dart';
import '../../utils/logger.dart';
import '../../widgets/cases/case_image_section.dart';
import '../../widgets/cases/findings_section.dart';
import '../../widgets/cases/impression_section.dart';
import '../../widgets/common/status_chip.dart';

/// Detailed view for a single case with generation and editing.
///
/// Generation/edit state is intentionally view-local (held in this State, not a
/// Riverpod provider): it is bound to TextEditingControllers, a ConfettiController,
/// and a success Timer, and is discarded on navigation — there is no cross-route
/// sharing requirement. A provider would have to mirror the same controller
/// lifecycle, doubling the state.
class CaseDetailView extends ConsumerStatefulWidget {
  const CaseDetailView({super.key, required this.caseId});

  final String caseId;

  @override
  ConsumerState<CaseDetailView> createState() => _CaseDetailViewState();
}

class _CaseDetailViewState extends ConsumerState<CaseDetailView> {
  final _editController = TextEditingController();
  final _findingsController = TextEditingController();
  final _scrollController = ScrollController();
  late final ConfettiController _confettiController;

  CaseDetail? _caseDetail;
  bool _isLoading = true;
  bool _isGenerating = false;
  bool _isSaving = false;
  bool _isEditingFindings = false;
  bool _isSavingFindings = false;

  GenerationPhase _generationPhase = GenerationPhase.starting;
  SavePhase _savePhase = SavePhase.saving;

  String? _generatedImpression;
  String? _baseImpression;
  List<AppliedPreference> _preferencesApplied = [];
  int _preferencesUsed = 0;
  String? _baseImpressionModel;
  String? _refinementModel;
  GenerationTrace? _generationTrace;

  String? _errorMessage;
  String? _successMessage;
  EditStatusResponse? _saveResult;

  Timer? _successTimer;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadCaseDetail();
    // Listen to text changes to update canSave state
    _editController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Trigger rebuild to update canSave
    setState(() {});
  }

  @override
  void didUpdateWidget(CaseDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.caseId != widget.caseId) {
      _loadCaseDetail();
    }
  }

  @override
  void dispose() {
    _editController.removeListener(_onTextChanged);
    _editController.dispose();
    _findingsController.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    _successTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCaseDetail({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _generatedImpression = null;
        _baseImpression = null;
        _preferencesApplied = [];
        _generationTrace = null;
        _saveResult = null;
      });
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      final detail = await apiService.getCaseDetail(widget.caseId);
      setState(() {
        _caseDetail = detail;
        if (!silent) {
          // Only update text fields on initial load
          _findingsController.text = detail.findings;
          _editController.text = detail.currentImpression ?? '';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load case: ${friendlyError(e)}';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateImpression() async {
    if (_caseDetail == null) return;

    setState(() {
      _isGenerating = true;
      _generationPhase = GenerationPhase.starting;
      _errorMessage = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final clinicalInterpretation =
          ref.read(clinicalInterpretationProvider);

      // Simulate phase progression for UI feedback
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _generationPhase = GenerationPhase.retrieving);

      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _generationPhase = GenerationPhase.generating);

      final response = await apiService.generateImpression(
        caseId: widget.caseId,
        findings: _findingsController.text,
        clinicalInterpretation: clinicalInterpretation,
      );

      setState(() => _generationPhase = GenerationPhase.refining);
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _generatedImpression = response.impression;
        _baseImpression = response.baseImpression;
        _preferencesApplied = response.preferencesApplied;
        _preferencesUsed = response.preferencesUsed;
        _baseImpressionModel = response.baseImpressionModel;
        _refinementModel = response.refinementModel;
        _generationTrace = response.trace;
        _editController.text = response.impression;
        _isGenerating = false;
        _generationPhase = GenerationPhase.finishing;
      });

      // Refresh case detail to update status (silent to preserve scroll)
      await _loadCaseDetail(silent: true);
      // Refresh cases list
      ref.invalidate(casesProvider);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate: ${friendlyError(e)}';
        _isGenerating = false;
      });
    }
  }

  Future<void> _saveEdit() async {
    final originalImpression =
        _generatedImpression ?? _caseDetail?.generatedImpression;
    if (originalImpression == null) return;

    final editedImpression = _editController.text.trim();
    if (editedImpression == originalImpression) {
      _showSuccess('No changes to save');
      return;
    }

    setState(() {
      _isSaving = true;
      _savePhase = SavePhase.saving;
      _errorMessage = null;
      _saveResult = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);

      final result = await apiService.saveEdit(
        caseId: widget.caseId,
        originalImpression: originalImpression,
        editedImpression: editedImpression,
        findings: _findingsController.text,
        onPhaseChange: (phase) {
          setState(() => _savePhase = phase);
        },
      );

      setState(() {
        _isSaving = false;
        _saveResult = result;
      });

      if (result.isFailed) {
        setState(() {
          _errorMessage = result.errorMessage ?? 'Save failed';
        });
      } else {
        // Update the "original" to the saved value so Save Edit button disables
        setState(() {
          _generatedImpression = editedImpression;
        });

        // Check if preferences were learned
        if (result.preferencesSaved != null && result.preferencesSaved!.isNotEmpty) {
          // D10: Set new-preferences badge
          final localPrefs = ref.read(sharedPreferencesProvider);
          ref.read(hasNewPreferencesProvider.notifier).state = true;
          localPrefs.setBool(kHasNewPreferencesKey, true);

          // D8: Confetti on first preference ever
          if (!(localPrefs.getBool(kFirstPreferenceConfettiKey) ?? false)) {
            localPrefs.setBool(kFirstPreferenceConfettiKey, true);
            _confettiController.play();
          }
        }

        _showSuccess('Edit saved successfully');
        // Refresh data (silent to preserve scroll)
        await _loadCaseDetail(silent: true);
        ref.invalidate(casesProvider);
        ref.invalidate(preferencesProvider);
        ref.invalidate(rejectedPreferencesProvider);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save: ${friendlyError(e)}';
        _isSaving = false;
      });
    }
  }

  Future<void> _updateFindings() async {
    devLog('[CaseDetail] _updateFindings for case ${widget.caseId} '
        '(findings length=${_findingsController.text.length})');

    setState(() {
      _isSavingFindings = true;
      _errorMessage = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.updateCase(widget.caseId, _findingsController.text);
      devLog('[CaseDetail] updateCase API succeeded');
      setState(() {
        _isEditingFindings = false;
        _isSavingFindings = false;
      });
      _showSuccess('Findings updated');
      await _loadCaseDetail(silent: true);
      ref.invalidate(casesProvider);
    } catch (e) {
      devLog('[CaseDetail] updateCase API failed');
      setState(() {
        _errorMessage = 'Failed to update findings: ${friendlyError(e)}';
        _isSavingFindings = false;
      });
    }
  }

  void _showSuccess(String message) {
    setState(() => _successMessage = message);
    _successTimer?.cancel();
    _successTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _successMessage = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_caseDetail == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(_errorMessage ?? 'Case not found'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadCaseDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyG, control: true): () {
          if (!_isGenerating && !_isSaving) _generateImpression();
        },
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
          if (!_isGenerating && !_isSaving && _canSave) _saveEdit();
        },
      },
      child: Focus(
        autofocus: true,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Messages
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: TimingConstants.mediumTransitionMs),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: _errorMessage != null
                        ? Padding(
                            key: ValueKey('error-$_errorMessage'),
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildErrorMessage(),
                          )
                        : const SizedBox.shrink(key: ValueKey('no-error')),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: TimingConstants.mediumTransitionMs),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: _successMessage != null
                        ? Padding(
                            key: ValueKey('success-$_successMessage'),
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildSuccessMessage(),
                          )
                        : const SizedBox.shrink(key: ValueKey('no-success')),
                  ),

                  // X-ray Image section
                  if (_caseDetail!.imageUrls != null &&
                      _caseDetail!.imageUrls!.isNotEmpty) ...[
                    CaseImageSection(imageUrls: _caseDetail!.imageUrls!),
                    const SizedBox(height: 24),
                  ],

                  // Findings section
                  FindingsSection(
                    controller: _findingsController,
                    isEditing: _isEditingFindings,
                    isSaving: _isSavingFindings,
                    onEditToggle: () =>
                        setState(() => _isEditingFindings = !_isEditingFindings),
                    onSave: _updateFindings,
                    onCancel: () {
                      setState(() {
                        _findingsController.text = _caseDetail!.findings;
                        _isEditingFindings = false;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Impression section
                  ImpressionSection(
                    caseDetail: _caseDetail!,
                    generatedImpression: _generatedImpression,
                    baseImpression: _baseImpression,
                    preferencesApplied: _preferencesApplied,
                    preferencesUsed: _preferencesUsed,
                    baseImpressionModel: _baseImpressionModel,
                    refinementModel: _refinementModel,
                    generationTrace: _generationTrace,
                    editController: _editController,
                    isGenerating: _isGenerating,
                    isSaving: _isSaving,
                    generationPhase: _generationPhase,
                    savePhase: _savePhase,
                    onGenerate: _generateImpression,
                    onSave: _saveEdit,
                    canSave: _canSave,
                  ),
                  const SizedBox(height: 24),

                  // Save result
                  if (_saveResult != null) ...[
                    _buildSaveResult(),
                  ],
                ],
              ),
            ),
            // Confetti overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
                maxBlastForce: 20,
                minBlastForce: 8,
                gravity: 0.3,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canSave {
    // Compare against the most recent version: locally generated, or the
    // persisted current impression (editedImpression ?? generatedImpression)
    final original = _generatedImpression ?? _caseDetail?.currentImpression;
    return original != null && _editController.text.trim() != original;
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Case ${widget.caseId}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  StatusChip(
                    label: _caseDetail!.hasGenerated ? 'Done' : 'New',
                    color: _caseDetail!.hasGenerated
                        ? Colors.green
                        : colorScheme.primary,
                  ),
                  if (_caseDetail!.wasEdited)
                    const StatusChip(
                      label: 'Edited',
                      color: Colors.orange,
                    ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: _loadCaseDetail,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.onErrorContainer),
            onPressed: () => setState(() => _errorMessage = null),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _successMessage!,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveResult() {
    final colorScheme = Theme.of(context).colorScheme;
    final result = _saveResult!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.isFailed ? Icons.error_outline : Icons.check_circle,
                  color: result.isFailed ? colorScheme.error : colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  result.isFailed ? 'Save Failed' : 'Save Complete',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (result.summary != null) ...[
              const SizedBox(height: 8),
              Text(result.summary!),
            ],
            if (result.preferencesSaved != null &&
                result.preferencesSaved!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Preferences Learned:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              ...result.preferencesSaved!.map((p) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.add_circle,
                            size: 16, color: colorScheme.secondary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(p.preferenceText)),
                      ],
                    ),
                  )),
            ],
            if (result.changesRejected != null &&
                result.changesRejected!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Changes Rejected:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              ...result.changesRejected!.map((r) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.remove_circle,
                            size: 16, color: colorScheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.changeDescription),
                              Text(
                                r.reason,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            if (result.safetyWarning != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: colorScheme.tertiary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.safetyWarning!,
                        style: TextStyle(color: colorScheme.onTertiaryContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
