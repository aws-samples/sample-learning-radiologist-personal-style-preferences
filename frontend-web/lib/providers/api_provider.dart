import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';
import 'auth_provider.dart';

/// The single injection seam for the data layer.
///
/// Every data provider fetches through this. Tests override THIS provider with a
/// fake `ApiService` rather than stubbing individual providers — see
/// `test/providers/_fakes.dart` and `docs/state-management.md`.
final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiService(authService);
});
