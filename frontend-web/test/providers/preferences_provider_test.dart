import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/preference.dart';
import 'package:report_preferences_web/providers/preferences_provider.dart';
import 'package:report_preferences_web/services/api_service.dart';

import '_fakes.dart';

/// Exercises the REAL sorted/filtered preference providers through a
/// ProviderContainer with a faked API — replaces preferences_logic_test.dart.

const _samplePrefs = [
  Preference(preferenceId: 'p1', preferenceText: 'Use bullet points for list items', category: 'formatting', timestamp: 1700000001, confidence: 0.92),
  Preference(preferenceId: 'p2', preferenceText: 'Be concise in impression text', category: 'detail_level', timestamp: 1700000003, confidence: 0.85),
  Preference(preferenceId: 'p3', preferenceText: 'Use "opacity" instead of "consolidation"', category: 'terminology', timestamp: 1700000002, confidence: 0.95),
  Preference(preferenceId: 'p4', preferenceText: 'List acute findings before chronic', category: 'priority', timestamp: 1700000004, confidence: 0.78),
  Preference(preferenceId: 'p5', preferenceText: 'Prefer active voice phrasing', timestamp: 1700000000), // null category/confidence
];

const _sampleRejected = [
  RejectedPreference(rejectionId: 'r1', changeDescription: 'Added a recommendation for CT', rejectionReason: 'Adds clinical content', timestamp: 1700000001),
  RejectedPreference(rejectionId: 'r2', changeDescription: 'Inserted a differential diagnosis', rejectionReason: 'Content-adding keyword: differential', timestamp: 1700000003),
  RejectedPreference(rejectionId: 'r3', changeDescription: 'Suggested follow-up imaging', rejectionReason: 'Adds clinical recommendation', timestamp: 1700000002),
];

void main() {
  late FakeApiService api;

  ProviderContainer container({
    List<Preference> prefs = _samplePrefs,
    List<RejectedPreference> rejected = _sampleRejected,
    Object? prefsError,
    Object? rejectedError,
  }) {
    api = FakeApiService()
      ..prefs = prefs
      ..rejected = rejected
      ..prefsError = prefsError
      ..rejectedError = rejectedError;
    return makeContainer(api: api, addTearDown: addTearDown);
  }

  Future<void> loadPrefs(ProviderContainer c) => c.read(preferencesProvider.future);
  Future<void> loadRejected(ProviderContainer c) => c.read(rejectedPreferencesProvider.future);

  group('sortedPreferencesProvider — sort', () {
    test('recent: timestamp descending', () async {
      final c = container();
      await loadPrefs(c);
      final ids = c.read(sortedPreferencesProvider).value!.map((p) => p.preferenceId);
      expect(ids, ['p4', 'p2', 'p3', 'p1', 'p5']);
    });

    test('category: alphabetical, null category last', () async {
      final c = container();
      await loadPrefs(c);
      c.read(preferenceSortProvider.notifier).state = PreferenceSort.category;
      final ids = c.read(sortedPreferencesProvider).value!.map((p) => p.preferenceId);
      // detail_level, formatting, priority, terminology, (null -> 'zzz')
      expect(ids, ['p2', 'p1', 'p4', 'p3', 'p5']);
    });

    test('confidence: descending, null confidence last', () async {
      final c = container();
      await loadPrefs(c);
      c.read(preferenceSortProvider.notifier).state = PreferenceSort.confidence;
      final ids = c.read(sortedPreferencesProvider).value!.map((p) => p.preferenceId);
      // 0.95, 0.92, 0.85, 0.78, (null -> 0)
      expect(ids, ['p3', 'p1', 'p2', 'p4', 'p5']);
    });
  });

  group('sortedPreferencesProvider — search', () {
    test('matches preference text (case-insensitive)', () async {
      final c = container();
      await loadPrefs(c);
      c.read(preferenceSearchProvider.notifier).state = 'BULLET';
      expect(c.read(sortedPreferencesProvider).value!.single.preferenceId, 'p1');
    });

    test('matches category', () async {
      final c = container();
      await loadPrefs(c);
      c.read(preferenceSearchProvider.notifier).state = 'terminology';
      expect(c.read(sortedPreferencesProvider).value!.single.preferenceId, 'p3');
    });

    test('null-category item still searchable by text', () async {
      final c = container();
      await loadPrefs(c);
      c.read(preferenceSearchProvider.notifier).state = 'active voice';
      expect(c.read(sortedPreferencesProvider).value!.single.preferenceId, 'p5');
    });

    test('empty search returns all; no-match returns empty', () async {
      final c = container();
      await loadPrefs(c);
      expect(c.read(sortedPreferencesProvider).value, hasLength(5));
      c.read(preferenceSearchProvider.notifier).state = 'zzzzz';
      expect(c.read(sortedPreferencesProvider).value, isEmpty);
    });
  });

  group('sortedPreferencesProvider — async states', () {
    test('loading before fetch completes', () {
      final c = container();
      expect(c.read(sortedPreferencesProvider).isLoading, isTrue);
    });

    test('error propagates as AsyncError', () async {
      final c = container(prefsError: ApiException(500, 'boom'));
      await expectLater(loadPrefs(c), throwsA(isA<ApiException>()));
      expect(c.read(sortedPreferencesProvider).hasError, isTrue);
    });
  });

  group('sortedRejectedPreferencesProvider', () {
    test('sorts by timestamp descending', () async {
      final c = container();
      await loadRejected(c);
      final ids = c.read(sortedRejectedPreferencesProvider).value!.map((r) => r.rejectionId);
      expect(ids, ['r2', 'r3', 'r1']);
    });

    test('search matches changeDescription', () async {
      final c = container();
      await loadRejected(c);
      c.read(preferenceSearchProvider.notifier).state = 'differential';
      expect(c.read(sortedRejectedPreferencesProvider).value!.single.rejectionId, 'r2');
    });

    test('search matches rejectionReason', () async {
      final c = container();
      await loadRejected(c);
      c.read(preferenceSearchProvider.notifier).state = 'clinical';
      expect(c.read(sortedRejectedPreferencesProvider).value, hasLength(2));
    });

    test('error propagates as AsyncError', () async {
      final c = container(rejectedError: ApiException(500, 'boom'));
      await expectLater(loadRejected(c), throwsA(isA<ApiException>()));
      expect(c.read(sortedRejectedPreferencesProvider).hasError, isTrue);
    });
  });
}
