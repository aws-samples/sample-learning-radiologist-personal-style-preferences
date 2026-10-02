import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/case.dart';
import 'package:report_preferences_web/providers/cases_provider.dart';
import 'package:report_preferences_web/services/api_service.dart';

import '_fakes.dart';

/// Exercises the REAL cases providers (filteredCasesProvider,
/// caseFilterCountsProvider) through a ProviderContainer with a faked API —
/// replaces the old cases_logic_test.dart, which tested a copy of the logic.

const _sampleCases = [
  Case(caseId: 'Case_001', findings: 'No acute cardiopulmonary abnormality.'),
  Case(caseId: 'Case_002', findings: 'Mild cardiomegaly. Bibasilar atelectasis.', hasGenerated: true),
  Case(caseId: 'Case_003', findings: 'Right lower lobe pneumonia.', hasGenerated: true, hasEdited: true),
  Case(caseId: 'Case_004', findings: 'Normal chest radiograph.'),
  Case(caseId: 'Case_005', findings: 'Bilateral pleural effusions.', hasGenerated: true, hasEdited: true),
];

void main() {
  late FakeApiService api;

  ProviderContainer container({List<Case> cases = _sampleCases, Object? error}) {
    api = FakeApiService()
      ..cases = cases
      ..casesError = error;
    return makeContainer(api: api, addTearDown: addTearDown);
  }

  // Resolve the underlying future so the composed providers see data.
  Future<void> loadCases(ProviderContainer c) => c.read(casesProvider.future);

  group('filteredCasesProvider', () {
    test('filter=all returns every case', () async {
      final c = container();
      await loadCases(c);
      final result = c.read(filteredCasesProvider);
      expect(result.value, hasLength(5));
    });

    test('filter=new_ returns only ungenerated cases', () async {
      final c = container();
      await loadCases(c);
      c.read(caseFilterProvider.notifier).state = CaseFilter.new_;
      final result = c.read(filteredCasesProvider);
      expect(result.value!.map((e) => e.caseId), ['Case_001', 'Case_004']);
    });

    test('filter=done returns only generated cases', () async {
      final c = container();
      await loadCases(c);
      c.read(caseFilterProvider.notifier).state = CaseFilter.done;
      final result = c.read(filteredCasesProvider);
      expect(result.value!.map((e) => e.caseId),
          ['Case_002', 'Case_003', 'Case_005']);
    });

    test('search matches caseId (case-insensitive)', () async {
      final c = container();
      await loadCases(c);
      c.read(caseSearchProvider.notifier).state = 'case_003';
      expect(c.read(filteredCasesProvider).value, hasLength(1));
    });

    test('search matches findings text', () async {
      final c = container();
      await loadCases(c);
      c.read(caseSearchProvider.notifier).state = 'pneumonia';
      final result = c.read(filteredCasesProvider).value!;
      expect(result.single.caseId, 'Case_003');
    });

    test('filter + search combine (done + pleural -> 1)', () async {
      final c = container();
      await loadCases(c);
      c.read(caseFilterProvider.notifier).state = CaseFilter.done;
      c.read(caseSearchProvider.notifier).state = 'pleural';
      expect(c.read(filteredCasesProvider).value, hasLength(1));
    });

    test('filter + search combine (new_ + pneumonia -> empty)', () async {
      final c = container();
      await loadCases(c);
      c.read(caseFilterProvider.notifier).state = CaseFilter.new_;
      c.read(caseSearchProvider.notifier).state = 'pneumonia';
      expect(c.read(filteredCasesProvider).value, isEmpty);
    });

    test('no-match search returns empty', () async {
      final c = container();
      await loadCases(c);
      c.read(caseSearchProvider.notifier).state = 'zzzzz';
      expect(c.read(filteredCasesProvider).value, isEmpty);
    });

    test('empty source returns empty data', () async {
      final c = container(cases: const []);
      await loadCases(c);
      expect(c.read(filteredCasesProvider).value, isEmpty);
    });

    test('loading state propagates before the fetch completes', () {
      final c = container();
      // Not awaited — casesProvider is still loading.
      expect(c.read(filteredCasesProvider).isLoading, isTrue);
    });

    test('error propagates through .when() as AsyncError', () async {
      final c = container(error: ApiException(500, 'boom'));
      await expectLater(loadCases(c), throwsA(isA<ApiException>()));
      final result = c.read(filteredCasesProvider);
      expect(result.hasError, isTrue);
      expect(result.error, isA<ApiException>());
    });
  });

  group('caseFilterCountsProvider', () {
    test('counts with no search; new_ + done == all', () async {
      final c = container();
      await loadCases(c);
      final counts = c.read(caseFilterCountsProvider).value!;
      expect(counts[CaseFilter.all], 5);
      expect(counts[CaseFilter.new_], 2);
      expect(counts[CaseFilter.done], 3);
      expect(counts[CaseFilter.new_]! + counts[CaseFilter.done]!,
          counts[CaseFilter.all]);
    });

    test('counts reflect the active search', () async {
      final c = container();
      await loadCases(c);
      c.read(caseSearchProvider.notifier).state = 'pleural';
      final counts = c.read(caseFilterCountsProvider).value!;
      expect(counts[CaseFilter.all], 1);
      expect(counts[CaseFilter.new_], 0);
      expect(counts[CaseFilter.done], 1);
    });

    test('empty source -> all zero', () async {
      final c = container(cases: const []);
      await loadCases(c);
      final counts = c.read(caseFilterCountsProvider).value!;
      expect(counts.values, everyElement(0));
    });

    test('error propagates as AsyncError', () async {
      final c = container(error: ApiException(500, 'boom'));
      await expectLater(loadCases(c), throwsA(isA<ApiException>()));
      expect(c.read(caseFilterCountsProvider).hasError, isTrue);
    });
  });
}
