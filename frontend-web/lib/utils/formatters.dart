import 'package:intl/intl.dart';

/// Format a Unix timestamp to a human-readable date string
String formatTimestamp(double timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
  return DateFormat.yMMMd().format(date);
}

/// Format a Unix timestamp to date and time
String formatTimestampWithTime(double timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
  return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

/// Convert model ID to display name
String formatModelName(String modelId) {
  if (modelId.contains('claude-opus-4-8')) return 'Claude Opus 4.8';
  if (modelId.contains('claude-opus-4-6')) return 'Claude Opus 4.6';
  if (modelId.contains('claude-sonnet-4-6')) return 'Claude Sonnet 4.6';
  if (modelId.contains('claude-sonnet-4-5')) return 'Claude Sonnet 4.5';
  if (modelId.contains('claude-haiku-4-5')) return 'Claude Haiku 4.5';
  return modelId;
}
