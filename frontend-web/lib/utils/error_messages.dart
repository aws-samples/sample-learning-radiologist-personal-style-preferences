import 'package:dio/dio.dart';

import '../services/api_service.dart' show ApiException;

/// Maps any thrown object to a safe, user-facing message.
///
/// Never returns raw exception text. `DioException.toString()` embeds the
/// request URL and frequently the response body — which for this app contains
/// PHI (findings / impression text) — so rendering it on screen is both a data
/// exposure and poor UX. This helper prefers the backend's curated
/// `{error: {message}}` envelope (already sanitized server-side), then falls
/// back to a generic message keyed by HTTP status.
String friendlyError(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is ApiException) {
    return _forStatus(error.statusCode, error.message);
  }

  if (error is DioException) {
    // Prefer the backend's structured, sanitized error envelope when present.
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final err = data['error'];
      if (err is Map<String, dynamic> && err['message'] is String) {
        return err['message'] as String;
      }
    }
    final status = error.response?.statusCode;
    if (status != null) {
      return _forStatus(status, null);
    }
    return 'Network error. Check your connection and try again.';
  }

  return fallback;
}

/// Generic, PHI-free message for an HTTP status. [serverMessage] is used only
/// when it came from our own curated envelope (already safe to show).
String _forStatus(int status, String? serverMessage) {
  if (serverMessage != null && serverMessage.isNotEmpty) {
    return serverMessage;
  }
  switch (status) {
    case 400:
      return 'That request was invalid. Please check your input and try again.';
    case 401:
    case 403:
      return 'Your session has expired. Please sign in again.';
    case 404:
      return 'We couldn\'t find what you were looking for.';
    case 408:
      return 'The request timed out. Please try again.';
    case 413:
      return 'That text is too long. Please shorten it and try again.';
    case 429:
      return 'Too many requests. Please wait a moment and try again.';
    default:
      if (status >= 500) {
        return 'The server ran into a problem. Please try again shortly.';
      }
      return 'Something went wrong. Please try again.';
  }
}
