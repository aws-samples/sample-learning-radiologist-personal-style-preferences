import 'package:flutter/material.dart';

import '../../config/api_constants.dart';
import '../../config/app_theme.dart';

/// Onboarding walkthrough dialog
class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_OnboardingPage> _buildPages(ColorScheme cs) => [
        _OnboardingPage(
          illustration: _IllustrationWelcome(colorScheme: cs),
          title: 'Welcome to Report Preferences',
          description:
              'An AI-powered tool that learns your radiological impression style '
              'and applies it to future generations.',
        ),
        _OnboardingPage(
          illustration: _IllustrationGenerate(colorScheme: cs),
          title: 'Generate Impressions',
          description:
              'Select a case and click "Generate" to create an AI-powered impression '
              'from the findings. The system uses your learned preferences to match your style.',
        ),
        _OnboardingPage(
          illustration: _IllustrationEdit(colorScheme: cs),
          title: 'Teach Your Style',
          description:
              'Edit the generated impression to match your preferred style, then click '
              '"Save Edit". The system will learn from your changes.',
        ),
        _OnboardingPage(
          illustration: _IllustrationPreferences(colorScheme: cs),
          title: 'Review Preferences',
          description:
              'View all learned preferences in the Preferences tab. You can see exactly '
              'how each preference was inferred and delete any you don\'t want.',
        ),
        _OnboardingPage(
          illustration: _IllustrationSafety(colorScheme: cs),
          title: 'Safety Built-In',
          description:
              'The system only learns style preferences (formatting, phrasing, terminology). '
              'Clinical content changes are automatically rejected for safety.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pages = _buildPages(colorScheme);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        SizedBox(
                          height: 160,
                          width: 200,
                          child: page.illustration,
                        ),
                        const SizedBox(height: 24),
                        // Title
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Page indicator with animated dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: TimingConstants.mediumTransitionMs),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: TimingConstants.onboardingPageTransitionMs),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 80),
                  if (_currentPage < pages.length - 1)
                    FilledButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: TimingConstants.onboardingPageTransitionMs),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Next'),
                    )
                  else
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Get Started'),
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

class _OnboardingPage {
  const _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.description,
  });

  final Widget illustration;
  final String title;
  final String description;
}

// ── Illustration widgets ────────────────────────────────────────────────────

/// Page 1 — Welcome: teal gradient "RP" monogram with sparkle icons
class _IllustrationWelcome extends StatelessWidget {
  const _IllustrationWelcome({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main gradient circle with RP monogram
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.teal, Color(0xFF00695C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x5900897B),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'RP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            // Sparkle top-right
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.auto_awesome,
                size: 16,
                color: colorScheme.primary,
              ),
            ),
            // Sparkle bottom-left
            Positioned(
              bottom: 8,
              left: 8,
              child: Icon(
                Icons.auto_awesome,
                size: 16,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page 2 — Generate: Findings → AI → Impression pipeline
class _IllustrationGenerate extends StatelessWidget {
  const _IllustrationGenerate({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Findings box
          _PipelineBox(
            colorScheme: colorScheme,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Findings',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                ...[0.8, 0.6, 0.7].map(
                  (w) => _MockTextLine(
                    widthFactor: w,
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          _Arrow(colorScheme: colorScheme),
          // AI box
          _PipelineBox(
            colorScheme: colorScheme,
            child: Icon(
              Icons.auto_awesome,
              size: 28,
              color: colorScheme.secondary,
            ),
          ),
          _Arrow(colorScheme: colorScheme),
          // Impression box
          _PipelineBox(
            colorScheme: colorScheme,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Impression',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                ...[0.8, 0.6, 0.7].map(
                  (w) => _MockTextLine(
                    widthFactor: w,
                    color: colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Page 3 — Edit: before/after diff card
class _IllustrationEdit extends StatelessWidget {
  const _IllustrationEdit({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original row (with strikethrough fragment)
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 32,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.error.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Container(
                          height: 1,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Edited row (with teal highlight)
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 32,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Pencil icon top-right
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.edit,
                size: 16,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page 4 — Preferences: mock preference card with category chip + confidence
class _IllustrationPreferences extends StatelessWidget {
  const _IllustrationPreferences({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Teal left border accent
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Two mock text lines
                      _MockTextLine(widthFactor: 0.9, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                      const SizedBox(height: 4),
                      _MockTextLine(widthFactor: 0.7, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                      const SizedBox(height: 8),
                      // Chip + confidence badge row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.label, size: 10, color: colorScheme.onSecondaryContainer),
                                const SizedBox(width: 3),
                                Text(
                                  'Formatting',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '92%',
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
      ),
    );
  }
}

/// Page 5 — Safety: shield + style-allowed / clinical-rejected rows
class _IllustrationSafety extends StatelessWidget {
  const _IllustrationSafety({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield,
            size: 56,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const _SafetyRow(
            icon: Icons.check_circle,
            iconColor: Color(0xFF2E7D32),
            label: 'Style preferences',
            allowed: true,
          ),
          const SizedBox(height: 8),
          const _SafetyRow(
            icon: Icons.cancel,
            iconColor: Color(0xFFC62828),
            label: 'Clinical content',
            allowed: false,
          ),
        ],
      ),
    );
  }
}

// ── Shared helper widgets ───────────────────────────────────────────────────

class _PipelineBox extends StatelessWidget {
  const _PipelineBox({required this.colorScheme, required this.child});

  final ColorScheme colorScheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.arrow_forward,
        size: 16,
        color: colorScheme.secondary,
      ),
    );
  }
}

class _MockTextLine extends StatelessWidget {
  const _MockTextLine({required this.widthFactor, required this.color});

  final double widthFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _SafetyRow extends StatelessWidget {
  const _SafetyRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.allowed,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool allowed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Text(
          '$label  ${allowed ? '✓' : '✗'}',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
