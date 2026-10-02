import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/models/case.dart';
import 'package:report_preferences_web/providers/cases_provider.dart';

import '_fakes.dart';

/// Verifies the .autoDispose semantics added in the hardening pass: providers
/// release their cache when unwatched, and invalidate (logout) forces a refetch.

void main() {
  late FakeApiService api;

  ProviderContainer makeC() {
    api = FakeApiService()
      ..cases = const [Case(caseId: 'c1', findings: 'x')];
    return makeContainer(api: api, addTearDown: addTearDown);
  }

  test('casesProvider disposes when unwatched and refetches on next read', () async {
    final c = makeC();

    // First listener resolves the fetch (1 call), then is removed.
    final sub = c.listen(casesProvider, (_, __) {});
    await c.read(casesProvider.future);
    expect(api.getCasesCalls, 1);
    sub.close();

    // autoDispose teardown is scheduled asynchronously — let it run.
    await pumpEventQueue();

    // With no listeners, the autoDispose provider is torn down; reading again
    // rebuilds and refetches.
    await c.read(casesProvider.future);
    expect(api.getCasesCalls, 2);
  });

  test('a kept-open listener prevents refetch', () async {
    final c = makeC();
    final sub = c.listen(casesProvider, (_, __) {});
    addTearDown(sub.close);

    await c.read(casesProvider.future);
    await c.read(casesProvider.future);
    expect(api.getCasesCalls, 1);
  });

  test('invalidate clears the cache (logout) and forces a refetch', () async {
    final c = makeC();
    final sub = c.listen(casesProvider, (_, __) {});
    addTearDown(sub.close);

    await c.read(casesProvider.future);
    expect(api.getCasesCalls, 1);

    c.invalidate(casesProvider);
    await c.read(casesProvider.future);
    expect(api.getCasesCalls, 2);
  });
}
