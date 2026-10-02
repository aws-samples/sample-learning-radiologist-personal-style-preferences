import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:report_preferences_web/models/case.dart';
import 'package:report_preferences_web/providers/cases_provider.dart';
import 'package:report_preferences_web/providers/local_storage_provider.dart';
import 'package:report_preferences_web/screens/cases/cases_screen.dart';

/// Build a [ProviderScope] with the minimal overrides needed for CasesScreen.
///
/// Uses [pump] instead of [pumpAndSettle] because FloatingIcon has a repeating
/// AnimationController that never settles.
Widget _buildCasesScreen({
  required List<Case> cases,
  String? selectedCaseId,
  required SharedPreferences prefs,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      casesProvider.overrideWith((_) async => cases),
      selectedCaseIdProvider.overrideWith((ref) => selectedCaseId),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: CasesScreen(),
      ),
    ),
  );
}

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  // ===========================================================================
  // _EmptyState — CTA button visibility
  //
  // The CTA "Start with first new case →" should appear when there is at least
  // one case that hasn't been generated yet, and must set selectedCaseIdProvider
  // when tapped.
  // ===========================================================================

  group('_EmptyState CTA button', () {
    testWidgets(
        'button is visible when an ungenerated case exists',
        (tester) async {
      await tester.pumpWidget(_buildCasesScreen(
        cases: [
          const Case(caseId: 'Case_001', findings: 'Findings.', hasGenerated: false),
        ],
        prefs: prefs,
      ));
      await tester.pump();
      await tester.pump();

      expect(find.text('Start with first new case →'), findsOneWidget);
    });

    testWidgets(
        'button is absent when all cases are generated',
        (tester) async {
      await tester.pumpWidget(_buildCasesScreen(
        cases: [
          const Case(caseId: 'Case_001', hasGenerated: true),
          const Case(caseId: 'Case_002', hasGenerated: true),
        ],
        prefs: prefs,
      ));
      await tester.pump();
      await tester.pump();

      expect(find.text('Start with first new case →'), findsNothing);
    });

    testWidgets(
        'button is absent when cases list is empty',
        (tester) async {
      await tester.pumpWidget(_buildCasesScreen(cases: [], prefs: prefs));
      await tester.pump();
      await tester.pump();

      expect(find.text('Start with first new case →'), findsNothing);
    });

    testWidgets(
        'tapping CTA sets selectedCaseIdProvider to the first ungenerated case',
        (tester) async {
      late WidgetRef capturedRef;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            casesProvider.overrideWith((_) async => [
                  const Case(caseId: 'Case_001', hasGenerated: true),
                  const Case(caseId: 'Case_002', hasGenerated: false),
                ]),
            selectedCaseIdProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  capturedRef = ref;
                  // Render only CasesScreen empty-state portion.
                  // Wrapping in Consumer gives us a ref to inspect the provider.
                  return const CasesScreen();
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Tap the CTA — this sets selectedCaseIdProvider synchronously.
      await tester.tap(find.text('Start with first new case →'));
      // Do NOT pump after tap: pumping would render CaseDetailView, which
      // issues a real network request and leaves a pending Dio timer.

      expect(capturedRef.read(selectedCaseIdProvider), 'Case_002');
    });
  });

  // ===========================================================================
  // _EmptyState — static content
  // ===========================================================================

  group('_EmptyState static content', () {
    testWidgets('shows expected title, body, and keyboard hint', (tester) async {
      await tester.pumpWidget(_buildCasesScreen(cases: [], prefs: prefs));
      await tester.pump();
      await tester.pump();

      expect(find.text('Ready to get started?'), findsOneWidget);
      expect(find.textContaining('Select a case from the list'), findsOneWidget);
      expect(find.textContaining('Ctrl+G'), findsOneWidget);
    });
  });
}
