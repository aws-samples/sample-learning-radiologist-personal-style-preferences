import 'package:flutter/foundation.dart';

/// Debug-only logger.
///
/// [debugPrint] is NOT compiled out of release/profile builds — on Flutter web
/// it writes to the browser console, where it would expose PHI (findings /
/// impression text), request bodies, and token-adjacent error detail to anyone
/// with devtools open. Routing all logging through [devLog] makes "is this safe
/// in release?" a single audited decision: it no-ops entirely outside debug.
///
/// Even in debug, prefer logging shapes/lengths over raw payloads — debug builds
/// are sometimes run against real data.
void devLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
